#!/usr/bin/env sage
#  Modified on: Mar 15, 2013
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

import sys
load Stribog.sage
load Stribog_2_8.sage

def generate_test_data_h():
	r"""
	Generate file test_data.h for testing C version of Stribog.
	"""
	s = Stribog()

	out = open("test_data.h","w")

	s.tools.generate_test_data_h(number_of_messages=2048,fout=out)

	out.close()

def generateTableCParameters():
	r"""
	Generate file stribog_data.h and stribog.c.
	"""
	s=Stribog()
	
	out = open("stribog_data.h","w")

	s.tools.generate_stribog_data_h(fout=out)

	out.close()

	out = open("stribog.c","w")

	s.tools.generateF_8_64(fout=out)

	out.close()

def self_testing():
	r"""
	Test the Sage version of Stribog using vectors from the specification.
	"""
	s=Stribog()
	
	s.selfTesting()

def self_testing_2_8():
	s=Stribog()
	s28=Stribog_2_8()
	
	s28.selfTesting()

	M = ZZ(randint(0,2^4000-1))

	s28.setMessage(message=M,length=4000,version="512")
	s.setMessage(message=M,length=4000,version="512")
	
	h 	= s.hash()
	h28 = s28.hash()
	if h == h28:
		print "Equivalent = True"
	else:
		print "Equivalent = False"

def main(argv=None):

	t1 = cputime()

	generate_test_data_h()
	generateTableCParameters()

	print "Selftesting of the standard implementation"
	self_testing()

	print "Selftesting of the implementation over GF(2^8)"
	self_testing_2_8()

	t2 = cputime()
	
	print "Time = {0}".format(t2-t1)
	
if __name__ == "__main__":
	sys.exit(main())
