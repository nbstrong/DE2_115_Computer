/*
 * main.cpp
 *
 *  Created on: Nov 15, 2021
 *      Author: MushinZero
 */

#include "system.h"
#include <stdint.h>
#include <stdio.h>

#define USERINPUT 0

// Number of repetitions for performance test
#define N (100000)

int euclids_mod(int a, int b);

int main(void) {
    int a, b = 0;
    volatile int gcd_ci, gcd_sw = 0;

    while(1) {
        // Got tired of inputting numbers, change #define at top
        if(USERINPUT) {
        printf("\nInput A: ");
        scanf(" %u",&a);
        printf("\nInput B: ");
        scanf(" %u",&b);
        }
        else {
            // a = 2147483647;
            // b = 524287;
            a = 91;
            b = 21;
        }
        printf("\nA: %u", a);
        printf("\nB: %u", b);

        gcd_sw = euclids_mod(a, b);
        gcd_ci = ALT_CI_GCD_CI_0(a, b);

        printf("\nGCD_SW: %i", gcd_sw);
        printf("\nGCD_CI: %i", gcd_ci);

        char ch;
        printf("\n\nPress ENTER to continue.");
        scanf("%c",&ch);
    }
}

int euclids_mod(int a, int b)
{
    int amb = a % b;
    if(amb == 0) {
        return b;}
    return euclids_mod(b, amb);
}


