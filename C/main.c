/*
 * main.c
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
 *		Acknowledgments: Oleksii Shevchuk
 */

#include "main.h"

void self_testing()
{
	unsigned char h512[64]={}, h256[32] = {};
	int i=0;

	for(i=0;i<TEST_VECTORS;i++)
	{
		hash_512(Message[i],MessageLength[i],h512);

		if(memcmp(h512,Hash_512[i],sizeof(unsigned char)*64))
		{
			printf("  SelfTesting: Fail\n");
			printf("    Version: 512\n");
			printf("    Message: %d\n",i);
			return;
		}

		hash_256(Message[i],MessageLength[i],h256);

		if(memcmp(h256,Hash_256[i],sizeof(unsigned char)*32))
		{
			printf("  SelfTesting: Fail\n");
			printf("    Version: 256\n");
			printf("    Message: %d\n",i);
			return;
		}
	}

	printf("  SelfTesting: Pass\n");
}

unsigned int get_random_number(int bits)
{
    unsigned int rnd=0;

    rnd=(unsigned int)__rdtsc();

    return ( (unsigned int) ( ((unsigned long long)1<<bits)  * ((double)rand_r(&rnd) / (double)RAND_MAX  )) )&( ((unsigned long long)1<<bits) - 1);
}

void performance_test()
{
	unsigned long long clk=0, i=0, N_test = 20000; // 2000000
	char cipher_name[]="Stribog";
	long double rate=0, Mbit=0;

	unsigned char h512[64] = {
		0xd8,0xd9,0x9f,0x12,0x8d,0x9f,0x2b,0x9e,0xf2,0x66,0x4a,0x9a,0xdd,0x08,0x9f,0xfa,
		0xfc,0xdc,0x7a,0x39,0x59,0x64,0x64,0x4e,0x4a,0x46,0x4f,0x26,0x0c,0x8e,0x64,0xc4,
		0x1d,0x98,0x84,0xc7,0x94,0xfb,0x0b,0x74,0x68,0xe0,0x64,0xc6,0x7d,0x7a,0xf1,0xe9,
		0x30,0x2c,0x80,0xdd,0x4f,0xc0,0x37,0x04,0x54,0xd8,0x79,0xcb,0x4a,0xa2,0xcf,0x87
	};

	for(i=0;i<64;i++)
	{
		h512[i]=(unsigned char)get_random_number(8);
	}

	hash_512(h512,511,h512);
	clk = __rdtsc();
	//////////////////////////
	for(i=0; i<N_test; i++)
		hash_512(h512,511,h512);
	//////////////////////////
	clk = __rdtsc() - clk;

	Mbit = 512; // block in bits
	rate = N_test;
	rate /= clk;
	rate *= 1000*1000; rate *= CPU_MHZ;
	Mbit /= (1024*1024);
	printf("  Hash = %s\n",cipher_name);
	printf("  Performance: %.2Lf Blk/sec = %.3Lf MBit/sec = %lld ticks\n\n",rate, rate*Mbit,clk/N_test);
}

int main()
{
	self_testing();
	performance_test();

	return 0;
}
