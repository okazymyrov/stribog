/*
 * stribog.c
 *
 *  Ceated on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 */

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <math.h>

#include <xmmintrin.h>
#include <x86intrin.h>

#include "stribog.h"
#include "stribog_data.h"

void LOG_state(char *var, unsigned char *state, unsigned long long len)
{
	unsigned long long i=0;

	printf("%s: ",var);
	for(i=0;i<len;i++)
		printf("%.2x",state[i]);
	printf("\n");
}

void AddModulo512(unsigned char *a,unsigned char *b,unsigned char *c)
{
	int i = 0, t = 0;

	for(i=63;i>=0;i--)
	{
		t = a[i] + b[i] + (t >> 8);
		c[i] = t & 0xFF;
	}
}

void AddXor512(void *a,void *b,void *c)
{
	int i = 0;
	__m128 *A=a, *B=b, *C=c;

	for(i=0;i<4;i++)
	{
            C[i] = _mm_xor_ps(A[i], B[i]);
        }
}

void F(unsigned char *state)
{
	unsigned int return_state[16]={};

        __builtin_prefetch(state, 1, 1);

        const unsigned long long
	t1 = T[0][state[63]]
            ^ T[1][state[55]]
            ^ T[2][state[47]]
            ^ T[3][state[39]]
            ^ T[4][state[31]]
            ^ T[5][state[23]]
            ^ T[6][state[15]]
            ^ T[7][state[ 7]];

	const unsigned long long
        t2 = T[0][state[62]]
            ^ T[1][state[54]]
            ^ T[2][state[46]]
            ^ T[3][state[38]]
            ^ T[4][state[30]]
            ^ T[5][state[22]]
            ^ T[6][state[14]]
            ^ T[7][state[ 6]];

	const unsigned long long
        t3 = T[0][state[61]]
            ^ T[1][state[53]]
            ^ T[2][state[45]]
            ^ T[3][state[37]]
            ^ T[4][state[29]]
            ^ T[5][state[21]]
            ^ T[6][state[13]]
            ^ T[7][state[ 5]];

        const unsigned long long
        t4 = T[0][state[60]]
	   ^ T[1][state[52]]
	   ^ T[2][state[44]]
	   ^ T[3][state[36]]
	   ^ T[4][state[28]]
	   ^ T[5][state[20]]
	   ^ T[6][state[12]]
	   ^ T[7][state[ 4]];

        const unsigned long long
        t5 = T[0][state[59]]
	   ^ T[1][state[51]]
	   ^ T[2][state[43]]
	   ^ T[3][state[35]]
	   ^ T[4][state[27]]
	   ^ T[5][state[19]]
	   ^ T[6][state[11]]
	   ^ T[7][state[ 3]];

        const unsigned long long
        t6 = T[0][state[58]]
	   ^ T[1][state[50]]
	   ^ T[2][state[42]]
	   ^ T[3][state[34]]
	   ^ T[4][state[26]]
	   ^ T[5][state[18]]
	   ^ T[6][state[10]]
	   ^ T[7][state[ 2]];

        const unsigned long long
        t7 = T[0][state[57]]
	   ^ T[1][state[49]]
	   ^ T[2][state[41]]
	   ^ T[3][state[33]]
	   ^ T[4][state[25]]
	   ^ T[5][state[17]]
	   ^ T[6][state[ 9]]
	   ^ T[7][state[ 1]];

        const unsigned long long
        t8 = T[0][state[56]]
	   ^ T[1][state[48]]
	   ^ T[2][state[40]]
	   ^ T[3][state[32]]
	   ^ T[4][state[24]]
	   ^ T[5][state[16]]
	   ^ T[6][state[ 8]]
	   ^ T[7][state[ 0]];

        return_state[15] = _bswap(t1	     & 0xFFFFFFFF);
	return_state[14] = _bswap((t1 >> 32) & 0xFFFFFFFF);
	return_state[13] = _bswap(t2	     & 0xFFFFFFFF);
	return_state[12] = _bswap((t2 >> 32) & 0xFFFFFFFF);
	return_state[11] = _bswap(t3	     & 0xFFFFFFFF);
	return_state[10] = _bswap((t3 >> 32) & 0xFFFFFFFF);
	return_state[ 9] = _bswap(t4	     & 0xFFFFFFFF);
	return_state[ 8] = _bswap((t4 >> 32) & 0xFFFFFFFF);
	return_state[ 7] = _bswap(t5	     & 0xFFFFFFFF);
	return_state[ 6] = _bswap((t5 >> 32) & 0xFFFFFFFF);
	return_state[ 5] = _bswap(t6	     & 0xFFFFFFFF);
	return_state[ 4] = _bswap((t6 >> 32) & 0xFFFFFFFF);
	return_state[ 3] = _bswap(t7	     & 0xFFFFFFFF);
	return_state[ 2] = _bswap((t7 >> 32) & 0xFFFFFFFF);
	return_state[ 1] = _bswap(t8	     & 0xFFFFFFFF);
	return_state[ 0] = _bswap((t8 >> 32) & 0xFFFFFFFF);

        memcpy(state, return_state, 64);
}

void E(unsigned char *K,unsigned char *m, unsigned char *state)
{
    int i=0;

    AddXor512(m,K,state);

    for(i=0;i<12;i++)
    {
	AddXor512(K,C[i],K);
        F(state);
	F(K);
        AddXor512(state,K,state);
    }
}

void g_N(unsigned char *N,unsigned char *h,unsigned char *m)
{
    unsigned char K[64] __attribute__((aligned(16)));
    unsigned char t[64] __attribute__((aligned(16)));

    AddXor512(N,h,K);

    F(K);

    E(K,m,t);

    AddXor512(t,h,t);
    AddXor512(t,m,h);
}

void hash_X(unsigned char *IV,unsigned char *message,unsigned long long len,unsigned char *out)
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
	unsigned char Sigma[64] = {}, N[64] = {}, m[64] = {}, hash[64] = {}, *M=NULL;

	// Stage 1
        memcpy(hash, IV, 64);

        __builtin_prefetch(T[1], 0, 3); // Real WTF :D
        __builtin_prefetch(T[2], 0, 3); // More then 7% misses at T1/T2.
        __builtin_prefetch(T[3], 0, 3);
        __builtin_prefetch(T[4], 0, 3);

	M = (unsigned char *)alloca(len);
        __builtin_prefetch(M, 1, 3);
        memcpy(M, message, (len -3)/8 + 1);

	// Stage 2
	while (len >= 512)
	{
            memcpy(m, M + (len-3)/8-63, 64);

            g_N(N,hash,m);
            AddModulo512(N,v512,N);
            AddModulo512(Sigma,m,Sigma);
            len -= 512;
	}

        bzero(m, 64);
        memcpy(m + 63 - (len-3)/8, M, (len-3)/8 + 1);

	// Stage 3
	m[ 63 - (int)(len/8) ] |= 1 << (len % 8);

	g_N(N,hash,m);
	v512[63] = len & 0xFF;
	v512[62] = (len & 0xFF00) >> 8;
	AddModulo512(N,v512,N);
	AddModulo512(Sigma,m,Sigma);

	g_N(v0,hash,N);
	g_N(v0,hash,Sigma);

        memcpy(out, hash, 64);
}

void hash_512(unsigned char *message,unsigned long long length,unsigned char *out)
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

void hash_256(unsigned char *message,unsigned long long length,unsigned char *out)
{
	unsigned char IV[64] =
	{
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
	};
	unsigned char hash[64] = {};

	hash_X(IV,message,length,hash);

	memcpy(out,hash,32);
}
