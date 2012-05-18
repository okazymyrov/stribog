#!/usr/bin/env sage

#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>


from time import time
load Stribog.sage

def main(argv=None):
	s=Stribog()

	t1 = time()
	s.selfTesting()
	t2 = time()
	
	print "Time = {0}".format(t2-t1)
	
if __name__ == "__main__":
	sys.exit(main())
