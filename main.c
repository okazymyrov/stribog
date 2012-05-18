/*
 * main.c
 *
 *  Created on: May 5, 2012
 *      Author: Oleksandr Kazymyrov
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

void fill_with_random_bytes(unsigned char * output, size_t size)
{
    static int fd = -1;

    if (fd == -1)
    {
        fd = open("/dev/urandom", O_RDONLY);
        if (fd == -1)
        {
            perror("Couldn't open random source: ");
            abort();
        }
    }

    if (read(fd, output, size) == -1)
    {
        perror("Couldn't read random source: ");
        abort();
    }

}


void permofance_test()
{
    unsigned long long i, N_test = 0x1FFFFF;

	char cipher_name[]="Stribog_fast";
	long double rate, Mbit;

        struct timeval tv1, tv2;

	unsigned char h512[64] = {
		0xd8,0xd9,0x9f,0x12,0x8d,0x9f,0x2b,0x9e,0xf2,0x66,0x4a,0x9a,0xdd,0x08,0x9f,0xfa,
		0xfc,0xdc,0x7a,0x39,0x59,0x64,0x64,0x4e,0x4a,0x46,0x4f,0x26,0x0c,0x8e,0x64,0xc4,
		0x1d,0x98,0x84,0xc7,0x94,0xfb,0x0b,0x74,0x68,0xe0,0x64,0xc6,0x7d,0x7a,0xf1,0xe9,
		0x30,0x2c,0x80,0xdd,0x4f,0xc0,0x37,0x04,0x54,0xd8,0x79,0xcb,0x4a,0xa2,0xcf,0x87
	};

        fill_with_random_bytes(h512, sizeof(h512));

	hash_512(h512,511,h512);

        gettimeofday(&tv1, NULL);
        //////////////////////////
	for(i=0; i<N_test; i++)
		hash_512(h512,511,h512);
	//////////////////////////
        gettimeofday(&tv2, NULL);

	Mbit = 512; // block in bits
	rate = N_test;
	rate /= (tv2.tv_sec - tv1.tv_sec);
	Mbit /= (1024*1024);
	printf("  Hash = %s\n",cipher_name);
	printf("  Perfomance: %.2Lf Blk/sec = %.3Lf MBit/sec\n\n",rate, rate*Mbit);
}

int main()
{
	self_testing();
	permofance_test();

	return 0;
}
