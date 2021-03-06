/*
 * main.cpp
 *
 *  Created on: Nov 15, 2021
 *      Author: MushinZero
 */

#include "system.h"
#include <sys/alt_timestamp.h>
#include <stdint.h>
#include <stdio.h>

#define USERINPUT 1 // Whether to get user input or not
#define VECLENGTH 5 // Length of test vector array

#define INTERVAL_TIMER_BASE_PTR *(volatile uint32_t*)INTERVAL_TIMER_BASE

int euclids_sub(int a, int b);

unsigned int a_vec [VECLENGTH] = {
		91,
		1,
		1000000,
		2,
		2147483647
};
unsigned int b_vec [VECLENGTH] = {
		21,
		1,
		1,
		1023,
		524287
};

int main(void) {
    unsigned int a, b = 0;
    volatile unsigned int gcd_ci, gcd_sw = 0;

    for(int i = 0; i < VECLENGTH; i++) {
        unsigned int sw_timer_start, sw_timer_end, sw_timer_total = 0;
        unsigned int ci_timer_start, ci_timer_end, ci_timer_total = 0;

        // Got tired of inputting numbers, change #define at top
        if(USERINPUT && (i == 0)) {
        printf("\nInput A: ");
        scanf(" %u",&a);
        printf("\nInput B: ");
        scanf(" %u",&b);
        }
        else {
            a = a_vec[i];
            b = b_vec[i];
        }
        printf("\nA: %u", a);
        printf("\nB: %u", b);

        alt_timestamp_start();
        sw_timer_start = alt_timestamp();
        gcd_sw = euclids_sub(a, b);
        sw_timer_end = alt_timestamp();

        alt_timestamp_start();
        ci_timer_start = alt_timestamp();
        gcd_ci = ALT_CI_GCD_CI_0(a, b);
        ci_timer_end = alt_timestamp();

        sw_timer_total = sw_timer_end - sw_timer_start;
        ci_timer_total = ci_timer_end - ci_timer_start;

        printf("\nGCD_SW: %x", gcd_sw);
        printf("\nGCD_CI: %x", gcd_ci);
        printf("\nSW Cycles: %i SW Time: %E sec", sw_timer_total, ((float)sw_timer_total)/alt_timestamp_freq());
        printf("\nCI Cycles: %i CI Time: %E sec", ci_timer_total, ((float)ci_timer_total)/alt_timestamp_freq());
        printf("\nSpeedup: %f", ( (float)sw_timer_total/alt_timestamp_freq() ) / ( (float)ci_timer_total/alt_timestamp_freq() ) );

        printf("\n");
    }

    printf("\nFin.");
    return 0;
}

int euclids_sub(int a, int b)
{
    if (a == b) {
        return a;}
    if (a > b) {
        return euclids_sub((a-b), b);}
    else {
        return euclids_sub(a, (b-a));}
}



