/*
 * stribog.h
 *
 *  Created on: Feb 15, 2013
 *      Author: Oleksandr Kazymyrov
 *		Acknowledgments: Oleksii Shevchuk
 */

#ifndef STRIBOG_H_
#define STRIBOG_H_

void hash_512(const unsigned char *message,unsigned long long length,unsigned char *hash);
void hash_256(const unsigned char *message,unsigned long long length,unsigned char *hash);

#endif /* STRIBOG_H_ */
