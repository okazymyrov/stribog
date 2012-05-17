/*
 * main.h
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 */

#ifndef MAIN_H_
#define MAIN_H_

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <time.h>

#include "stribog.h"
#include "test_data.h"

//#define CPU_MHZ 1597 // Clock rate in MHz
//#define CPU_MHZ 2930 // Clock rate in MHz

#ifndef CPU_MHZ
#error The parameter CPU_MHZ is required!
#endif

#define __rdtsc() \
       ({  unsigned int _a = 0 ; \
           unsigned int _d = 0; \
           asm volatile("rdtsc" : "=a" (_a), "=d" (_d)); \
           ((( unsigned long long)_a) | (((unsigned long long)_d) << 32)); })

#endif /* MAIN_H_ */
