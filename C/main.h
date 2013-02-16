/*
 * main.h
 *
 *  Created on: Feb 15, 2013
 *      Author: Oleksandr Kazymyrov
 *		Acknowledgments: Oleksii Shevchuk
 */

#ifndef MAIN_H_
#define MAIN_H_

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <time.h>

#include "stribog.h"
#include "test_data.h"

#ifndef __linux__
#define __rdtsc() \
       ({  unsigned int _a = 0 ; \
           unsigned int _d = 0; \
           asm volatile("rdtsc" : "=a" (_a), "=d" (_d)); \
           ((( unsigned long long)_a) | (((unsigned long long)_d) << 32)); })
#endif

#endif /* MAIN_H_ */
