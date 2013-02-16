#!/usr/bin/env sage
#  Created on: Feb 15, 2013
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

import sys
load Stribog.sage

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

def main(argv=None):

	t1 = cputime()

	generate_test_data_h()
	generateTableCParameters()
	self_testing()

	t2 = cputime()
	
	print "Time = {0}".format(t2-t1)
	
if __name__ == "__main__":
	sys.exit(main())
