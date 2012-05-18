#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

load Data.sage
import pickle

class Tools(SageObject):
	def __init__(self, **kwargs):
		r'''
			Class for generation addition parameters for fast implementation.
		'''
		
		self.__T = None

	def generateF_8_64(self):
		r'''
			Function generate __F function for fast Stribog
		'''		
		
		print "\tdef __F(self,state):"
		print "\t\tr'''"
		print "\t\t\tFunction implements S, P and L function from specification"
		print "\t\t'''"
		print "\t\treturn_state = 0"
		print "\t\tt = 0"
		print ""
		
		for i in xrange(8):
			print "\t\t# i = {0}".format(i)
			for j in xrange(8):
				if i == 0 and j == 0:
					print "\t\tt = t ^^ ( T[{0}][ ( state & (0xFF       ) )        ] )".format(j)
					continue
				print "\t\tt = t ^^ ( T[{0}][ ( state & (0xFF << {1}) ) >> {2} ] )".format(j,repr(8*(Tau[8*i+j])).rjust(3),repr(8*(Tau[8*i+j])).rjust(3))
			print ""
			if i == 0:
				print "\t\treturn_state ^^= t"
			else:
				print "\t\treturn_state ^^= (t << {0})".format(i*64)
			if i != 7:
				print "\t\tt = 0"
			print ""

		print "\t\treturn return_state"

	def generateTable_8_64(self,number_of_tests=10):
		r'''
			Function creates substitution table 8 by 64 bits.
		'''		
		self.__generateTable_S_8_64()

		for i in xrange(number_of_tests):
			M=ZZ(randint(0,2^512-1))
			
			if self.__F_8_64(M) != self.__L(self.__P(self.__S(M))):
			#if self.__F_8_64(M) != self.__L(self.__S(self.__P(M))):
			#if self.__F_8_64(M) != self.__L(self.__S(M)):
				print "SelfTest = Fail"
				return

		print "SelfTest = Pass"

		return

		c_version=False
		if c_version is True:
			sys.stdout.write("unsigned long long T[8][256] = {\n")
			for i in xrange(8):
				sys.stdout.write("{\n\t")
				for j in xrange(256):
					if j != 255:
						sys.stdout.write("0x%.16X,"%self.__T[i][j])
						if (j+1) % 4 == 0:
							sys.stdout.write("\n\t")
					else:
						sys.stdout.write("0x%.16X\n"%self.__T[i][j])
						
				sys.stdout.write("},\n")
			sys.stdout.write("};\n")
		else:
			sys.stdout.write("T = [\n")
			for i in xrange(8):
				sys.stdout.write("[\n\t")
				for j in xrange(256):
					if j != 255:
						sys.stdout.write("0x%.16X,"%self.__T[i][j])
						if (j+1) % 4 == 0:
							sys.stdout.write("\n\t")
					else:
						sys.stdout.write("0x%.16X\n"%self.__T[i][j])
						
				sys.stdout.write("],\n")
			sys.stdout.write("]\n")

	def generateF_16_64(self):
		r'''
			Function generate __F function for fast Stribog
		'''		
		
		print "\tdef __F(self,state):"
		print "\t\tr'''"
		print "\t\t\tFunction implements S, P and L function from specification"
		print "\t\t'''"
		print "\t\treturn_state = 0"
		print "\t\tt = 0"
		print ""
		
		for i in xrange(8):
			print "\t\t# i = {0}".format(i)
			for j in xrange(4):
				print "\t\tt = t ^^ ( T[{0}][ ZZ([ ( state & ( 0xFF << {1} ) ) >> {1},( state & ( 0xFF << {2} ) ) >> {2} ],2^8) ] )".format(j,repr((8*Tau[8*i+2*j])).rjust(3),repr((8*Tau[8*i+2*j+1])).rjust(3))
			print ""
			if i == 0:
				print "\t\treturn_state ^^= t"
			else:
				print "\t\treturn_state ^^= (t << {0})".format(i*64)
			if i != 7:
				print "\t\tt = 0"
			print ""

		print "\t\treturn return_state"

	def generateTable_16_64(self,number_of_tests=10):
		r'''
			Function creates substitution table 8 by 64 bits.
		'''		
		self.__generateTable_S_16_64()

		for i in xrange(number_of_tests):
			M=ZZ(randint(0,2^512-1))
			
			if self.__F_16_64(M) != self.__L(self.__P(self.__S(M))):
			#if self.__F_16_64(M) != self.__L(self.__S(self.__P(M))):
			#if self.__F_16_64(M) != self.__L(self.__S(M)):
				print "SelfTest = Fail"
				return

		print "SelfTest = Pass"

		return

		c_version=True
		if c_version is True:
			sys.stdout.write("unsigned long long T[8][65536] = {\n")
			for i in xrange(4):
				sys.stdout.write("{\n\t")
				for j in xrange(65536):
					if j != 65535:
						sys.stdout.write("0x%.16X,"%self.__T[i][j])
						if (j+1) % 4 == 0:
							sys.stdout.write("\n\t")
					else:
						sys.stdout.write("0x%.16X\n"%self.__T[i][j])
						
				sys.stdout.write("},\n")
			sys.stdout.write("};\n")
		else:
			sys.stdout.write("T = [\n")
			for i in xrange(4):
				sys.stdout.write("[\n\t")
				for j in xrange(65536):
					if j != 65535:
						sys.stdout.write("0x%.16X,"%self.__T[i][j])
						if (j+1) % 4 == 0:
							sys.stdout.write("\n\t")
					else:
						sys.stdout.write("0x%.16X\n"%self.__T[i][j])
						
				sys.stdout.write("],\n")
			sys.stdout.write("]\n")
	def __generateTable_S_8_64(self):
		r'''
			Function creates substitution table 8 by 64 bits for __S and __L functions
		'''
		self.__T = [range(256) for i in xrange(8)]
		
		for i in xrange(8):
			for j in xrange(256):
				self.__T[i][j] = self.__L(Sbox[ZZ(j)] << 8*i)

	def __generateTable_S_16_64(self):
		r'''
			Function creates substitution table 16 by 64 bits for __S and __L functions
		'''
		path_to_db="./table.db"
		self.__T = [range(2^16) for i in xrange(4)]

		if os.path.isfile(path_to_db):
			pkl_file = open(path_to_db, 'rb')
			self.__T = pickle.load(pkl_file)
			pkl_file.close()
			return

		for i in xrange(4):
			print "i = {0}".format(i)
			for j in xrange(2^16):
				self.__T[i][j] = self.__L(ZZ([Sbox[ZZ(j).digits(2^8,padto=2)[0]],Sbox[ZZ(j).digits(2^8,padto=2)[1]]],2^8) << 16*i)

		output = open(path_to_db, 'wb')
		pickle.dump(self.__T, output)
		output.close()

	def __F_8_64(self,state):
		r'''
			Function includes S, P and L function from specification
		'''
		t = 0
		
		for i in xrange(8):
			for j in xrange(8):
				t = t ^^ ( self.__T[j][ ( state & (0xFF << (8*Tau[8*i+j])) ) >> (8*Tau[8*i+j]) ] << 64*i )

		return t

	def __F_16_64(self,state):
		r'''
			Function includes S, P and L function from specification
		'''
		t = 0
		
		for i in xrange(8):
			for j in xrange(4):
				t = t ^^ ( self.__T[j][ ZZ([ ( state & ( 0xFF << (8*Tau[8*i+2*j]) ) ) >> (8*Tau[8*i+2*j]),( state & ( 0xFF << (8*Tau[8*i+2*j+1]) ) ) >> (8*Tau[8*i+2*j+1]) ],2^8)  ] << 64*i )

		return t

	def __L(self,state):
		r'''
			Multiplication by matrix A
		'''
		t = 0
		
		for i in xrange(8):
			for j in xrange(64):
				if state.test_bit(64*i+j) == 1:
					t ^^= (A[63-j] << 64*i)

		return t
		
	def __L_matrix(self,state):
		r'''
			Multiplication by matrix A using exactly matrix
		'''
		B = A

		B = [list(reversed(g.digits(base=2,padto=64))) for g in B]

		B = Matrix(GF(2),64,64,B)

		t=state.digits(base=2^64,padto=8)
		t.reverse()

		t = [list(reversed(g.digits(base=2,padto=64))) for g in t]
		
		t = Matrix(GF(2),8,64,t)

		print "{0}".format(t.str())
		
		t = t * B
		
		t = [ZZ(list(reversed(g)),2) for g in t]
		t.reverse()
		
		t = sum([(2^64)^i*t[i] for i in xrange(len(t))])
	
		return t

	def __L_table(self,state):
		r'''
			Multiplication by matrix A using table.
			This function works only after __generateTable_L_8_64.
		'''
		t = 0

		for i in xrange(8):
			for j in xrange(8):
				t = t ^^ ( self.__T[j][ ( state & (0xFF << (64*i+8*j)) ) >> (64*i+8*j)] << 64*i )

		return t
		
	def __P(self,state):
		r'''
			Matrix Transposition operaion
		'''
		t = state.digits(base=2^8,padto=64)

		t = [t[Tau[g]] for g in xrange(64)]

		t = ZZ(t,2^8)
		
		return t

	def __P_matrix(self,state):
		r'''
			Matrix Transposition operaion
		'''
		t = state.digits(base=2^8,padto=64)
		t.reverse()
		
		t = Matrix(ZZ,8,8,t)

		t = t.transpose()
		
		t = t.list()

		t.reverse()
		t = ZZ(t,2^8)

		return t

	def __S(self,state):
		r'''
			SubBytes procedure
		'''		
		t = state.digits(base=2^8,padto=64)
		
		t = [Sbox[g] for g in t]
		
		t = ZZ(t,2^8)
		
		return t
