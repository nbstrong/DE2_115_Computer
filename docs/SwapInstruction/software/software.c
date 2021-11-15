/***********************************************
* Author: Igor Semenov (is0031@uah.edu)
* Platform: Terasic DE2-115
* Date: 10/27/2019
* Description:
*    This example demonstrates how to use a
*    custom instruction that swaps all bytes
*    in a word such that a Little Endian
*    number can be converter to a Big Endian
*    one or vise versa.
*    In this example we also compare the performance
*    of this custom instruction with its software-
*    implemented analog.
***********************************************/
#include <stdint.h>
#include <stdio.h>

// Register access for custom hardware clock counter
#define CCOUNTER_BASE (0x08200008)
#define CCOUNTER_RESET() *(volatile uint32_t*)(CCOUNTER_BASE + 0) = 0
#define CCOUNTER_GETL() (*(volatile uint32_t*)(CCOUNTER_BASE + 0))
#define CCOUNTER_GETH() (*(volatile uint32_t*)(CCOUNTER_BASE + 4))
#define CCOUNTER_CAPTURE() (CCOUNTER_GETL() | ((uint64_t)(CCOUNTER_GETH()) << 32))

// Instruction ID and call
#define INS_SWAP_ID 0x00
#define INS_SWAP(n) __builtin_custom_ini(INS_SWAP_ID,(n))

// Software analog
#define SW_SWAP(n) ((n>>24)&0xff) | ((n<<8)&0xff0000) | \
                   ((n>>8)&0xff00) | ((n<<24)&0xff000000)

// Number of repetitions for performance test
#define N (100000)

// Volatile variable to prevent optimizing out
// performance tests
volatile int x;

int main()
{
    volatile uint32_t littleEndian = 0xefbeadde;
    const uint32_t bigEndian = 0xdeadbeef;
    const uint32_t insBigEndian = INS_SWAP(littleEndian);
    const uint32_t swBigEndian = SW_SWAP(littleEndian);
    
    printf("Expected Big Endian: %lx\n", bigEndian);
    printf("Custom instruction Big Endian: %lx\n", insBigEndian);
    printf("Software Big Endian: %lx\n", swBigEndian);
    
    // Measure custom instruction performance
    CCOUNTER_RESET();
    for(int i = 0; i < N; i++) x = INS_SWAP(littleEndian);
    const uint64_t insTime = CCOUNTER_CAPTURE();
    
    // Measure software analog performance
    CCOUNTER_RESET();
    for(int i = 0; i < N; i++) x = SW_SWAP(littleEndian);
    const uint64_t swTime = CCOUNTER_CAPTURE();
    
    printf("Custom instruction exec time (N=%d): %llu cc\n", N, insTime);
    printf("Software exec time (N=%d): %llu cc\n", N, swTime);
    printf("Speedup: %f", 1.0 * swTime / insTime);
    
    while(1);
}
