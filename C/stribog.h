/*
 * stribog.h
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 *		Acknowledgments: Oleksii Shevchuk
 */

#ifndef STRIBOG_H_
#define STRIBOG_H_

void hash_512(unsigned char *message,unsigned long long length,unsigned char *hash);
void hash_256(unsigned char *message,unsigned long long length,unsigned char *hash);

#endif /* STRIBOG_H_ */
