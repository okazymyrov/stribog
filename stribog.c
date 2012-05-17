/*
 * stribog.c
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 */

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <math.h>

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
	unsigned long long *A=a, *B=b, *C=c;

	for(i=0;i<8;i++)
	{
		C[i] = A[i] ^ B[i];
	}
}

void F(unsigned char *state)
{
	unsigned char return_state[64]={};
	unsigned long long t = 0;
	int i=0;

	// i = 0
	t ^= T[0][state[63]];
	t ^= T[1][state[55]];
	t ^= T[2][state[47]];
	t ^= T[3][state[39]];
	t ^= T[4][state[31]];
	t ^= T[5][state[23]];
	t ^= T[6][state[15]];
	t ^= T[7][state[ 7]];

	return_state[56] = (t >> 56) & 0xFF;
	return_state[57] = (t >> 48) & 0xFF;
	return_state[58] = (t >> 40) & 0xFF;
	return_state[59] = (t >> 32) & 0xFF;
	return_state[60] = (t >> 24) & 0xFF;
	return_state[61] = (t >> 16) & 0xFF;
	return_state[62] = (t >>  8) & 0xFF;
	return_state[63] = (t      ) & 0xFF;
	t = 0;

	// i = 1
	t ^= T[0][state[62]];
	t ^= T[1][state[54]];
	t ^= T[2][state[46]];
	t ^= T[3][state[38]];
	t ^= T[4][state[30]];
	t ^= T[5][state[22]];
	t ^= T[6][state[14]];
	t ^= T[7][state[ 6]];

	return_state[48] = (t >> 56) & 0xFF;
	return_state[49] = (t >> 48) & 0xFF;
	return_state[50] = (t >> 40) & 0xFF;
	return_state[51] = (t >> 32) & 0xFF;
	return_state[52] = (t >> 24) & 0xFF;
	return_state[53] = (t >> 16) & 0xFF;
	return_state[54] = (t >>  8) & 0xFF;
	return_state[55] = (t      ) & 0xFF;
	t = 0;

	// i = 2
	t ^= T[0][state[61]];
	t ^= T[1][state[53]];
	t ^= T[2][state[45]];
	t ^= T[3][state[37]];
	t ^= T[4][state[29]];
	t ^= T[5][state[21]];
	t ^= T[6][state[13]];
	t ^= T[7][state[ 5]];

	return_state[40] = (t >> 56) & 0xFF;
	return_state[41] = (t >> 48) & 0xFF;
	return_state[42] = (t >> 40) & 0xFF;
	return_state[43] = (t >> 32) & 0xFF;
	return_state[44] = (t >> 24) & 0xFF;
	return_state[45] = (t >> 16) & 0xFF;
	return_state[46] = (t >>  8) & 0xFF;
	return_state[47] = (t      ) & 0xFF;
	t = 0;

	// i = 3
	t ^= T[0][state[60]];
	t ^= T[1][state[52]];
	t ^= T[2][state[44]];
	t ^= T[3][state[36]];
	t ^= T[4][state[28]];
	t ^= T[5][state[20]];
	t ^= T[6][state[12]];
	t ^= T[7][state[ 4]];

	return_state[32] = (t >> 56) & 0xFF;
	return_state[33] = (t >> 48) & 0xFF;
	return_state[34] = (t >> 40) & 0xFF;
	return_state[35] = (t >> 32) & 0xFF;
	return_state[36] = (t >> 24) & 0xFF;
	return_state[37] = (t >> 16) & 0xFF;
	return_state[38] = (t >>  8) & 0xFF;
	return_state[39] = (t      ) & 0xFF;
	t = 0;

	// i = 4
	t ^= T[0][state[59]];
	t ^= T[1][state[51]];
	t ^= T[2][state[43]];
	t ^= T[3][state[35]];
	t ^= T[4][state[27]];
	t ^= T[5][state[19]];
	t ^= T[6][state[11]];
	t ^= T[7][state[ 3]];

	return_state[24] = (t >> 56) & 0xFF;
	return_state[25] = (t >> 48) & 0xFF;
	return_state[26] = (t >> 40) & 0xFF;
	return_state[27] = (t >> 32) & 0xFF;
	return_state[28] = (t >> 24) & 0xFF;
	return_state[29] = (t >> 16) & 0xFF;
	return_state[30] = (t >>  8) & 0xFF;
	return_state[31] = (t      ) & 0xFF;
	t = 0;

	// i = 5
	t ^= T[0][state[58]];
	t ^= T[1][state[50]];
	t ^= T[2][state[42]];
	t ^= T[3][state[34]];
	t ^= T[4][state[26]];
	t ^= T[5][state[18]];
	t ^= T[6][state[10]];
	t ^= T[7][state[ 2]];

	return_state[16] = (t >> 56) & 0xFF;
	return_state[17] = (t >> 48) & 0xFF;
	return_state[18] = (t >> 40) & 0xFF;
	return_state[19] = (t >> 32) & 0xFF;
	return_state[20] = (t >> 24) & 0xFF;
	return_state[21] = (t >> 16) & 0xFF;
	return_state[22] = (t >>  8) & 0xFF;
	return_state[23] = (t      ) & 0xFF;
	t = 0;

	// i = 6
	t ^= T[0][state[57]];
	t ^= T[1][state[49]];
	t ^= T[2][state[41]];
	t ^= T[3][state[33]];
	t ^= T[4][state[25]];
	t ^= T[5][state[17]];
	t ^= T[6][state[ 9]];
	t ^= T[7][state[ 1]];

	return_state[ 8] = (t >> 56) & 0xFF;
	return_state[ 9] = (t >> 48) & 0xFF;
	return_state[10] = (t >> 40) & 0xFF;
	return_state[11] = (t >> 32) & 0xFF;
	return_state[12] = (t >> 24) & 0xFF;
	return_state[13] = (t >> 16) & 0xFF;
	return_state[14] = (t >>  8) & 0xFF;
	return_state[15] = (t      ) & 0xFF;
	t = 0;

	// i = 7
	t ^= T[0][state[56]];
	t ^= T[1][state[48]];
	t ^= T[2][state[40]];
	t ^= T[3][state[32]];
	t ^= T[4][state[24]];
	t ^= T[5][state[16]];
	t ^= T[6][state[ 8]];
	t ^= T[7][state[ 0]];

	return_state[0] = (t >> 56) & 0xFF;
	return_state[1] = (t >> 48) & 0xFF;
	return_state[2] = (t >> 40) & 0xFF;
	return_state[3] = (t >> 32) & 0xFF;
	return_state[4] = (t >> 24) & 0xFF;
	return_state[5] = (t >> 16) & 0xFF;
	return_state[6] = (t >>  8) & 0xFF;
	return_state[7] = (t      ) & 0xFF;

	for(i=0;i<64;i++)
		state[i]=return_state[i];
}

#define KeySchedule(K,i) \
	AddXor512(K,C[i],K); \
	F(K);

void E(unsigned char *K,unsigned char *m, unsigned char *state)
{
	int i=0;

	AddXor512(m,K,state);

    for(i=0;i<12;i++)
    {
        F(state);
        KeySchedule(K,i);
        AddXor512(state,K,state);
    }
}

void g_N(unsigned char *N,unsigned char *h,unsigned char *m)
{
	unsigned char K[64] = {}, t[64] = {};

	AddXor512(N,h,K);

    F(K);

    E(K,m,t);

    AddXor512(t,h,t);
    AddXor512(t,m,h);
}

void hash_X(unsigned char *IV,unsigned char *message,unsigned long long length,unsigned char *out)
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
	unsigned long long len = length;
	int i=0, j=0;

	// Stage 1
	for(i=0;i<64;i++)
		hash[i]=IV[i];

	M = (unsigned char *)calloc(ceil((double)len/(double)8),sizeof(unsigned char));
	for(i=ceil((double)len/(double)8)-1;i >= 0;i--)
	{
		M[i]=message[i];
	}

	// Stage 2
	while (len >= 512)
	{
		for(j=63,i=ceil((double)len/(double)8)-1;i>ceil((double)len/(double)8)-1-64;i--,j--)
		{
			m[j] = M[i];
		}
		g_N(N,hash,m);
		AddModulo512(N,v512,N);
		AddModulo512(Sigma,m,Sigma);
		len -= 512;
	}

	for(i=0;i<64;i++)
		m[i]=0;

	for(j=63,i=ceil((double)len/(double)8)-1;i >= 0;i--,j--)
	{
		m[j] = M[i];
	}

	// Stage 3
	m[ 63 - (int)(len/8) ] |= 1 << (len % 8);

	g_N(N,hash,m);
	v512[63] = len & 0xFF;
	v512[62] = (len & 0xFF00) >> 8;
	AddModulo512(N,v512,N);
	AddModulo512(Sigma,m,Sigma);

	g_N(v0,hash,N);
	g_N(v0,hash,Sigma);

	for(i=0;i<64;i++)
		out[i]=hash[i];

	if(M != NULL)
		free(M);
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
