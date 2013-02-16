/*
 * stribog.c
 *
 *  Created on: Feb 15, 2013
 *      Author: Oleksandr Kazymyrov
 *		Acknowledgments: Oleksii Shevchuk
 */

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <math.h>

#include "stribog_data.h"

void AddModulo512(const void *a,const void *b,void *c)
{
	const unsigned char *A=a, *B=b;
	unsigned char *C=c;
	int t = 0;
#ifdef FULL_UNROLL
#define ADDBYTE_8(i) t = A[i] + B[i] + (t >> 8); C[i] = t & 0xFF;

	ADDBYTE_8(63)
	ADDBYTE_8(62)
	ADDBYTE_8(61)
	ADDBYTE_8(60)
	ADDBYTE_8(59)
	ADDBYTE_8(58)
	ADDBYTE_8(57)
	ADDBYTE_8(56)
	ADDBYTE_8(55)
	ADDBYTE_8(54)
	ADDBYTE_8(53)
	ADDBYTE_8(52)
	ADDBYTE_8(51)
	ADDBYTE_8(50)
	ADDBYTE_8(49)
	ADDBYTE_8(48)
	ADDBYTE_8(47)
	ADDBYTE_8(46)
	ADDBYTE_8(45)
	ADDBYTE_8(44)
	ADDBYTE_8(43)
	ADDBYTE_8(42)
	ADDBYTE_8(41)
	ADDBYTE_8(40)
	ADDBYTE_8(39)
	ADDBYTE_8(38)
	ADDBYTE_8(37)
	ADDBYTE_8(36)
	ADDBYTE_8(35)
	ADDBYTE_8(34)
	ADDBYTE_8(33)
	ADDBYTE_8(32)
	ADDBYTE_8(31)
	ADDBYTE_8(30)
	ADDBYTE_8(29)
	ADDBYTE_8(28)
	ADDBYTE_8(27)
	ADDBYTE_8(26)
	ADDBYTE_8(25)
	ADDBYTE_8(24)
	ADDBYTE_8(23)
	ADDBYTE_8(22)
	ADDBYTE_8(21)
	ADDBYTE_8(20)
	ADDBYTE_8(19)
	ADDBYTE_8(18)
	ADDBYTE_8(17)
	ADDBYTE_8(16)
	ADDBYTE_8(15)
	ADDBYTE_8(14)
	ADDBYTE_8(13)
	ADDBYTE_8(12)
	ADDBYTE_8(11)
	ADDBYTE_8(10)
	ADDBYTE_8(9)
	ADDBYTE_8(8)
	ADDBYTE_8(7)
	ADDBYTE_8(6)
	ADDBYTE_8(5)
	ADDBYTE_8(4)
	ADDBYTE_8(3)
	ADDBYTE_8(2)
	ADDBYTE_8(1)
	ADDBYTE_8(0)

#else
	int i = 0;

	for(i=63;i>=0;i--)
	{
		t = A[i] + B[i] + (t >> 8);
		C[i] = t & 0xFF;
	}
#endif
}

void AddXor512(const void *a,const void *b,void *c)
{
	const unsigned long long *A=a, *B=b;
	unsigned long long *C=c;
#ifdef FULL_UNROLL
	C[0] = A[0] ^ B[0];
	C[1] = A[1] ^ B[1];
	C[2] = A[2] ^ B[2];
	C[3] = A[3] ^ B[3];
	C[4] = A[4] ^ B[4];
	C[5] = A[5] ^ B[5];
	C[6] = A[6] ^ B[6];
	C[7] = A[7] ^ B[7];
#else
	int i = 0;

	for(i=0;i<8;i++)
	{
		C[i] = A[i] ^ B[i];
	}
#endif
}

void F(unsigned char *state)
{
	unsigned long long return_state[8] = {0,0,0,0,0,0,0,0};

	return_state[0] ^= T[0][state[56]];
	return_state[0] ^= T[1][state[48]];
	return_state[0] ^= T[2][state[40]];
	return_state[0] ^= T[3][state[32]];
	return_state[0] ^= T[4][state[24]];
	return_state[0] ^= T[5][state[16]];
	return_state[0] ^= T[6][state[8]];
	return_state[0] ^= T[7][state[0]];

	return_state[1] ^= T[0][state[57]];
	return_state[1] ^= T[1][state[49]];
	return_state[1] ^= T[2][state[41]];
	return_state[1] ^= T[3][state[33]];
	return_state[1] ^= T[4][state[25]];
	return_state[1] ^= T[5][state[17]];
	return_state[1] ^= T[6][state[9]];
	return_state[1] ^= T[7][state[1]];

	return_state[2] ^= T[0][state[58]];
	return_state[2] ^= T[1][state[50]];
	return_state[2] ^= T[2][state[42]];
	return_state[2] ^= T[3][state[34]];
	return_state[2] ^= T[4][state[26]];
	return_state[2] ^= T[5][state[18]];
	return_state[2] ^= T[6][state[10]];
	return_state[2] ^= T[7][state[2]];

	return_state[3] ^= T[0][state[59]];
	return_state[3] ^= T[1][state[51]];
	return_state[3] ^= T[2][state[43]];
	return_state[3] ^= T[3][state[35]];
	return_state[3] ^= T[4][state[27]];
	return_state[3] ^= T[5][state[19]];
	return_state[3] ^= T[6][state[11]];
	return_state[3] ^= T[7][state[3]];

	return_state[4] ^= T[0][state[60]];
	return_state[4] ^= T[1][state[52]];
	return_state[4] ^= T[2][state[44]];
	return_state[4] ^= T[3][state[36]];
	return_state[4] ^= T[4][state[28]];
	return_state[4] ^= T[5][state[20]];
	return_state[4] ^= T[6][state[12]];
	return_state[4] ^= T[7][state[4]];

	return_state[5] ^= T[0][state[61]];
	return_state[5] ^= T[1][state[53]];
	return_state[5] ^= T[2][state[45]];
	return_state[5] ^= T[3][state[37]];
	return_state[5] ^= T[4][state[29]];
	return_state[5] ^= T[5][state[21]];
	return_state[5] ^= T[6][state[13]];
	return_state[5] ^= T[7][state[5]];

	return_state[6] ^= T[0][state[62]];
	return_state[6] ^= T[1][state[54]];
	return_state[6] ^= T[2][state[46]];
	return_state[6] ^= T[3][state[38]];
	return_state[6] ^= T[4][state[30]];
	return_state[6] ^= T[5][state[22]];
	return_state[6] ^= T[6][state[14]];
	return_state[6] ^= T[7][state[6]];

	return_state[7] ^= T[0][state[63]];
	return_state[7] ^= T[1][state[55]];
	return_state[7] ^= T[2][state[47]];
	return_state[7] ^= T[3][state[39]];
	return_state[7] ^= T[4][state[31]];
	return_state[7] ^= T[5][state[23]];
	return_state[7] ^= T[6][state[15]];
	return_state[7] ^= T[7][state[7]];

	memcpy(state,(unsigned char*)return_state,64);
}

#define KeySchedule(K,i) AddXor512(K,C[i],K); F(K);

void E(unsigned char *K,const unsigned char *m, unsigned char *state)
{
#ifdef FULL_UNROLL
	AddXor512(m,K,state);

    F(state);
    KeySchedule(K,0);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,1);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,2);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,3);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,4);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,5);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,6);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,7);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,8);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,9);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,10);
    AddXor512(state,K,state);

    F(state);
    KeySchedule(K,11);
    AddXor512(state,K,state);
#else
	int i = 0;

	AddXor512(m,K,state);

    for(i=0;i<12;i++)
    {
        F(state);
        KeySchedule(K,i);
        AddXor512(state,K,state);
    }
#endif
}

void g_N(const unsigned char *N,unsigned char *h,const unsigned char *m)
{
	unsigned char t[64], K[64];

	AddXor512(N,h,K);

    F(K);

    E(K,m,t);

    AddXor512(t,h,t);
    AddXor512(t,m,h);
}

void hash_X(unsigned char *IV,const unsigned char *message,unsigned long long length,unsigned char *out)
{
	unsigned char v512[64] = {
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00
	};
	unsigned char v0[64] = {
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	};
	unsigned char Sigma[64] = {
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	};
	unsigned char N[64] = {
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	};
	unsigned char m[64], *hash = IV;
	unsigned long long len = length;

	// Stage 2
	while (len >= 512)
	{
		memcpy(m, message + len/8 - 63 - ( (len & 0x7) == 0 ), 64);

		g_N(N,hash,m);
		AddModulo512(N,v512,N);
		AddModulo512(Sigma,m,Sigma);
		len -= 512;
	}

	memset(m,0,64);
	memcpy(m + 63 - len/8 + ( (len & 0x7) == 0 ), message, len/8 + 1 - ( (len & 0x7) == 0 ));

	// Stage 3
	m[ 63 - len/8 ] |= (1 << (len & 0x7));

	g_N(N,hash,m);
	v512[63] = len & 0xFF;
	v512[62] = len >> 8;
	AddModulo512(N,v512,N);

	AddModulo512(Sigma,m,Sigma);

	g_N(v0,hash,N);
	g_N(v0,hash,Sigma);

	memcpy(out, hash, 64);
}

void hash_512(const unsigned char *message,unsigned long long length,unsigned char *out)
{
	unsigned char IV[64] =
	{
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	};

	hash_X(IV,message,length,out);
}

void hash_256(const unsigned char *message,unsigned long long length,unsigned char *out)
{
	unsigned char IV[64] =
	{
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
	};
	unsigned char hash[64];

	hash_X(IV,message,length,hash);

	memcpy(out,hash,32);
}
