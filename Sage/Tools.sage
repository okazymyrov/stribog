#  Created on: Feb 15, 2013
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

load Data.sage

class Tools(SageObject):
	def __init__(self, **kwargs):
		r'''
			This class generates additional parameters for fast implementation
		'''
		
		self.__T = None

	def generateF_8_64(self,fout=sys.stdout):
		r'''
			Write F function in fout stream
		'''		
		
		fout.write("void F(unsigned char *state)\n")
		fout.write("{\n")
		fout.write("\tunsigned long long return_state[8] = {0,0,0,0,0,0,0,0};\n\n")

		for i in xrange(8):
			for j in xrange(8):
				fout.write("\treturn_state[{0}] ^= T[{1}][state[{2}]];\n".format(i,j,56-8*j+i));
			fout.write("\n")			

		fout.write("\tmemcpy(state,(unsigned char*)return_state,64);\n")
		fout.write("}\n")

	def __generateTable_S_8_64(self):
		r'''
			Create substitution table 8 by 64 bits of __S and __L functions
		'''
		self.__T = [range(256) for i in xrange(8)]
		
		for i in xrange(8):
			for j in xrange(256):
				self.__T[i][j] = self.__L(Sbox[ZZ(j)] << 8*i)

	def __F_8_64(self,state):
		r'''
			Perform S, P and L transformations as defined in the specification
		'''
		t = 0
		
		for i in xrange(8):
			for j in xrange(8):
				t = t ^^ ( self.__T[j][ ( state & (0xFF << (8*Tau[8*i+j])) ) >> (8*Tau[8*i+j]) ] << 64*i )

		return t

	def __L(self,state):
		r'''
			Native multiplication with the matrix A.
		'''
		t = 0
		
		for i in xrange(8):
			for j in xrange(64):
				if state.test_bit(64*i+j) == 1:
					t ^^= (A[63-j] << 64*i)

		return t
		
	def __L_matrix(self,state):
		r'''
			Multiplication with the matrix A using matrix representation
		'''
		B = A

		B = [list(reversed(g.digits(base=2,padto=64))) for g in B]

		B = Matrix(GF(2),64,64,B)

		t=state.digits(base=2^64,padto=8)
		t.reverse()

		t = [list(reversed(g.digits(base=2,padto=64))) for g in t]
		
		t = Matrix(GF(2),8,64,t)

		t = t * B
		
		t = [ZZ(list(reversed(g)),2) for g in t]
		t.reverse()
		
		t = sum([(2^64)^i*t[i] for i in xrange(len(t))])
	
		return t
		
	def __P(self,state):
		r'''
			Implement matrix transposition using tables
		'''
		t = state.digits(base=2^8,padto=64)

		t = [t[Tau[g]] for g in xrange(64)]

		t = ZZ(t,2^8)
		
		return t

	def __P_matrix(self,state):
		r'''
			Provide matrix transposition using ``transpose()`` function
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
			Each byte are maped using predefined substitution
		'''		
		t = state.digits(base=2^8,padto=64)
		
		t = [Sbox[g] for g in t]
		
		t = ZZ(t,2^8)
		
		return t

	def generate_stribog_data_h(self,number_of_tests=10,fout=sys.stdout):
		r'''
			Generate ``stribog_data.h`` file for C implementation

			INPUT: 

			- number_of_tests - integer (default: 10) the number of test cycles

			- fout - stream (default: sys.stdout) the stream on opened file

			OUTPUT: 

			``stribog_data.h`` file.
		'''		
		self.__generateTable_S_8_64()

		# SetfTesting of generated table
		for i in xrange(number_of_tests):
			M=ZZ(randint(0,2^512-1))
			
			if self.__F_8_64(M) != self.__L(self.__P(self.__S(M))):
				raise TypeError("generate_stribog_data_h: SelfTest is Fail")

		# Reverse table for fast implementation
		for i in xrange(8):
			for j in xrange(256):		
				self.__T[i][j] = ZZ(self.__T[i][j].digits(2^8,padto=8)[::-1],2^8)

		fout.write("/*\n")
 		fout.write("* stribog_data.h\n")
 		fout.write("*\n")
 		fout.write("*  Created on: Feb 15, 2013\n")
 		fout.write("*      Author: Oleksandr Kazymyrov\n")
 		fout.write("*		Acknowledgments: Oleksii Shevchuk\n")
 		fout.write("*/\n")

 		fout.write("#ifndef STRIBOG_DATA_H_\n")
 		fout.write("#define STRIBOG_DATA_H_\n\n")
 		fout.write("// Tables for function F\n")

		fout.write("const unsigned long long T[8][256] = {\n")
		for i in xrange(8):
			fout.write("{\n\t")
			for j in xrange(256):
				if j != 255:
					fout.write("0x%.16X,"%self.__T[i][j])
					if (j+1) % 4 == 0:
						fout.write("\n\t")
				else:
					fout.write("0x%.16X\n"%self.__T[i][j])
			if i == 7:
				fout.write("}\n")
			else:
				fout.write("},\n")
		fout.write("};\n\n")

		fout.write("// Constant values for KeySchedule function\n")
		fout.write("const unsigned char C[12][64] = {\n")
		for i in xrange(12):
			fout.write("{\n\t")
			for j in xrange(64):
				if j != 63:
					fout.write("0x%02X,"%C[i].digits(2^8,padto=64)[-(j+1)])
					if (j+1) % 16 == 0:
						fout.write("\n\t")
				else:
					fout.write("0x%02X\n"%C[i].digits(2^8,padto=64)[-(j+1)])
			if i == 11:
				fout.write("}\n")
			else:
				fout.write("},\n")
		fout.write("};\n\n")
		fout.write("#endif /* STRIBOG_DATA_H_ */\n")

	def generate_test_data_h(self,number_of_messages=2048,fout=sys.stdout):
		r'''
			Generate ``test_data.h`` file for C implementation

			INPUT: 

			- number_of_messages - integer (default: 2048) the number of generated messages

			- fout - stream (default: sys.stdout) the stream on opened file

			OUTPUT: 

			``test_data.h`` file.
		'''

		s = Stribog()

		Message 		= range(number_of_messages)
		Hash_512 		= range(number_of_messages)
		Hash_256 		= range(number_of_messages)
		MessageLength 	= range(number_of_messages)

		for i in xrange(number_of_messages):
			sys.stderr.write("\rData generation: [%-100s] %d%%" % ('='*(int(i*100/number_of_messages)), (i*100/number_of_messages).n(2)))
			sys.stderr.flush()
			Message[i] = randint(0,2^i-1)

			s.setMessage(message=Message[i],length=i,version="512")
			Hash_512[i] = s.hash()

			s.setMessage(message=Message[i],length=i,version="256")
			Hash_256[i] = s.hash()

		sys.stderr.write("\rData generation: [%-100s] %d%%\n" % ('='*100, 100))

		fout.write("/*\n")
	 	fout.write("* test_data.h\n")
	 	fout.write("*\n")
	 	fout.write("*  Created on: Feb 15, 2013\n")
	 	fout.write("*      Author: Oleksandr Kazymyrov\n")
	 	fout.write("*		Acknowledgments: Oleksii Shevchuk\n")
	 	fout.write("*/\n\n")
		fout.write("#ifndef TEST_DATA_H_\n")
		fout.write("#define TEST_DATA_H_\n")
		fout.write("#define TEST_VECTORS {0}\n".format(number_of_messages))
		fout.write("#define MAX_MESSAGE_LENGTH {0} // in bytes\n\n".format(ceil(number_of_messages/8)+1))

		fout.write("const unsigned char Message[TEST_VECTORS][MAX_MESSAGE_LENGTH] = {\n")
		for i in xrange(number_of_messages-1):
			M = Message[i]
			M = ZZ(M).digits(2^8,padto=ceil(i/8) + (i == 0))
			M.reverse()
			
			fout.write("\t{\n")
			for i in xrange(len(M)):
				if i%16 == 0:
					fout.write("\n\t\t")
				if i != len(M)-1:
					fout.write("0x%.2x,"%M[i])
				else:
					fout.write("0x%.2x\n"%M[i])
					break
			fout.write("\t},\n")

		i = number_of_messages-1
		M = Message[i]
		M = ZZ(M).digits(2^8,padto=1)
		M.reverse()
		
		fout.write("\t{\n")
		for i in xrange(len(M)):
			if i%16 == 0:
				fout.write("\n\t\t")
			if i != len(M)-1:
				fout.write("0x%.2x,"%M[i])
			else:
				fout.write("0x%.2x\n"%M[i])
				break
		fout.write("\t}\n};\n\n")

		fout.write("const unsigned char Hash_512[TEST_VECTORS][64] = {\n")
		for i in xrange(number_of_messages-1):
			M = Hash_512[i]
			M = ZZ(M).digits(2^8,padto=64)
			M.reverse()
			
			fout.write("\t{\n")
			for i in xrange(len(M)):
				if i%16 == 0:
					fout.write("\n\t\t")
				if i != len(M)-1:
					fout.write("0x%.2x,"%M[i])
				else:
					fout.write("0x%.2x\n"%M[i])
					break
			fout.write("\t},\n")

		i = number_of_messages-1
		M = Hash_512[i]
		M = ZZ(M).digits(2^8,padto=1)
		M.reverse()
		
		fout.write("\t{\n")
		for i in xrange(len(M)):
			if i%16 == 0:
				fout.write("\n\t\t")
			if i != len(M)-1:
				fout.write("0x%.2x,"%M[i])
			else:
				fout.write("0x%.2x\n"%M[i])
				break
		fout.write("\t}\n};\n\n")

		fout.write("const unsigned char Hash_256[TEST_VECTORS][32] = {\n")
		for i in xrange(number_of_messages-1):
			M = Hash_256[i]
			M = ZZ(M).digits(2^8,padto=32)
			M.reverse()
			
			fout.write("\t{\n")
			for i in xrange(len(M)):
				if i%16 == 0:
					fout.write("\n\t\t")
				if i != len(M)-1:
					fout.write("0x%.2x,"%M[i])
				else:
					fout.write("0x%.2x\n"%M[i])
					break
			fout.write("\t},\n")

		i = number_of_messages-1
		M = Hash_256[i]
		M = ZZ(M).digits(2^8,padto=1)
		M.reverse()
		
		fout.write("\t{\n")
		for i in xrange(len(M)):
			if i%16 == 0:
				fout.write("\n\t\t")
			if i != len(M)-1:
				fout.write("0x%.2x,"%M[i])
			else:
				fout.write("0x%.2x\n"%M[i])
				break
		fout.write("\t}\n};\n\n")

		fout.write("const unsigned long long MessageLength[TEST_VECTORS] = {\n")

		for i in xrange(number_of_messages):
			if i%16 == 0:
				fout.write("\n\t")
			if i != len(MessageLength) - 1:
				fout.write("0x%.3x,"%MessageLength[i])
			else:
				fout.write("0x%.3x\n};\n\n"%MessageLength[i])
				break

		fout.write("#endif /* TEST_DATA_H_ */\n")

