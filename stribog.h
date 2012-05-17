/*
 * stribog.h
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 */

#ifndef GOST3411_H_
#define GOST3411_H_

void kboxinit(void);

void hash_512(unsigned char *message,unsigned long long length,unsigned char *hash);
void hash_256(unsigned char *message,unsigned long long length,unsigned char *hash);

#endif /* GOST3411_H_ */
