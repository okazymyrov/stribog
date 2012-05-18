#!/usr/bin/env sage

#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

import sys
from time import time
load Stribog.sage

def generate_c_code():
	s=Stribog()

	length=randint(1,2^13-1)
	M = randint(0,2^length-1)
	
	s.setMessage(message=M,length=length,version="512")
	h_512=s.hash()

	s.setMessage(message=M,length=length,version="256")
	h_256=s.hash()

	#return
	
	print "int len = %d;\n"%length
	
	M=ZZ(M).digits(2^8)
	M.reverse()
	
	sys.stdout.write("unsigned char M[] = {\n\t")
	for i in xrange(len(M)):
		if i != len(M)-1:
			sys.stdout.write("0x%.2x,"%M[i])
		else:
			sys.stdout.write("0x%.2x\n"%M[i])
			break
		if (i+1)%16 == 0:
			sys.stdout.write("\n\t")
	sys.stdout.write("};\n\n")

	# 512
	h=ZZ(h_512).digits(2^8)
	h.reverse()

	sys.stdout.write("unsigned char H[] = {\n\t")
	for i in xrange(len(h)):
		if i != len(h)-1:
			sys.stdout.write("0x%.2x,"%h[i])
		else:
			sys.stdout.write("0x%.2x\n"%h[i])
			break
		if (i+1)%16 == 0:
			sys.stdout.write("\n\t")
	sys.stdout.write("};\n\n")

	# 256
	h=ZZ(h_256).digits(2^8)
	h.reverse()

	sys.stdout.write("unsigned char H[] = {\n\t")
	for i in xrange(len(h)):
		if i != len(h)-1:
			sys.stdout.write("0x%.2x,"%h[i])
		else:
			sys.stdout.write("0x%.2x\n"%h[i])
			break
		if (i+1)%16 == 0:
			sys.stdout.write("\n\t")
	sys.stdout.write("};\n\n")

def self_testing():
	s=Stribog()
	
	s.selfTesting()

def genTable_8_64():
	s=Stribog()
	
	s.tools.generateTable_8_64()
	s.tools.generateF_8_64()

def genTable_16_64():
	s=Stribog()
	
	s.tools.generateTable_16_64()
	s.tools.generateF_16_64()

def main(argv=None):

	#generate_c_code()
	self_testing()
	#genTable_8_64()
	#genTable_16_64()
	
if __name__ == "__main__":
	sys.exit(main())
