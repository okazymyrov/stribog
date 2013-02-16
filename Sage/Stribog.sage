#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

load Data.sage
load Tools.sage

class Stribog(SageObject):
	def __init__(self, **kwargs):
		r'''
			Native implimenstation of hash function Stribog.
		'''
		self.tools = Tools() # It is class provides additional functionality

	def __compress(self,Nn,h,m):
		r'''
			Realization g_N(h,m)
		'''
		K = h ^^ Nn

		#print "K={0}".format(hex(K).zfill(128))
		K = self.__S(K)
		#print "S={0}".format(hex(K).zfill(128))
		K = self.__P(K)
		#print "P={0}".format(hex(K).zfill(128))
		K = self.__L(K)
		#print "L={0}".format(hex(K).zfill(128))

		#print "m={0}".format(hex(m).zfill(128))		
		
		#exit(0)
		
		return self.__E(K,m) ^^ h ^^ m

	def __E(self,K,m):
		r'''
			Encryption procedure
		'''
		Ki    = K
		state = m ^^ Ki

		#print "state={0}".format(hex(state).zfill(128))
		
		for i in xrange(12):
			state = self.__S(state)
			#print "S={0}".format(hex(state).zfill(128))
			state = self.__P(state)
			#print "P={0}".format(hex(state).zfill(128))
			state = self.__L(state)
			#print "L={0}".format(hex(state).zfill(128))
			Ki = self.__KeySchedule(Ki,i)
			#print "Ki={0}".format(hex(Ki).zfill(128))
			state = state ^^ Ki
			#print "S={0}".format(hex(state).zfill(128))

		return state

	def hash(self):
		r'''
			Process stage 1, 2 and 3
		'''
		try:
			if self.__message == None:
				raise TypeError("Parameter 'message' is not defined")
		except NameError:
			raise TypeError("Parameter 'message' is not defined")

		self.__stage1()
		
		self.__stage2()
		
		self.__stage3()

		return self.__h

	def __KeySchedule(self,K,i):
		r'''
			Function generate K_{i+1} key
		'''
		Ki = K ^^ C[i]
		
		#print "Ki={0}".format(hex(Ki).zfill(128))
		
		Ki = self.__S(Ki)
		#print "S={0}".format(hex(Ki).zfill(128))
		Ki = self.__P(Ki)
		#print "P={0}".format(hex(Ki).zfill(128))
		Ki = self.__L(Ki)
		#print "L={0}".format(hex(Ki).zfill(128))
				
		return Ki

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
		
	def __P(self,state):
		r'''
			Matrix Transposition operaion
		'''
		t = state.digits(base=2^8,padto=64)

		t = [t[Tau[g]] for g in xrange(64)]

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
		
	def selfTesting(self):
		r'''
			Testing class using data from specification
		'''
		M1 = 0x323130393837363534333231303938373635343332313039383736353433323130393837363534333231303938373635343332313039383736353433323130
		M2 = 0xfbe2e5f0eee3c820fbeafaebef20fffbf0e1e0f0f520e0ed20e8ece0ebe5f0f2f120fff0eeec20f120faf2fee5e2202ce8f6f3ede220e8e6eee1e8f0f2d1202ce8f0f2e5e220e5d1

		H1_512 = 0x486f64c1917879417fef082b3381a4e211c324f074654c38823a7b76f830ad00fa1fbae42b1285c0352f227524bc9ab16254288dd6863dccd5b9f54a1ad0541b
		H1_256 = 0x00557be5e584fd52a449b16b0251d05d27f94ab76cbaa6da890b59d8ef1e159d

		H2_512 = 0x28fbc9bada033b1460642bdcddb90c3fb3e56c497ccd0f62b8a2ad4935e85f037613966de4ee00531ae60f3b5a47f8dae06915d5f2f194996fcabf2622e6881e
		H2_256 = 0x508f7e553c06501d749a66fc28c6cac0b005746d97537fa85d9e40904efed29d
		
		self.setMessage(message=M1,length=504,version="512")
		h = self.hash()
		if h == H1_512:
			print "M1/512 = Pass"
		else:
			print "M1/512 = Fail"

		self.setMessage(message=M1,length=504,version="256")
		h = self.hash()
		if h == H1_256:
			print "M1/256 = Pass"
		else:
			print "M1/256 = Fail"

		self.setMessage(message=M2,length=576,version="512")
		h = self.hash()
		if h == H2_512:
			print "M2/512 = Pass"
		else:
			print "M2/512 = Fail"

		self.setMessage(message=M2,length=576,version="256")
		h = self.hash()
		if h == H2_256:
			print "M2/256 = Pass"
		else:
			print "M2/256 = Fail"

		
	def setMessage(self, **kwargs):
		r'''
			Arguments:
				message - a bit string for hashing
				length  - length of 'message' in bits
				version - length of the hash value. Can take values "256" and "512".
		'''
		self.__message = kwargs.get('message',None)
		self.__message_length = kwargs.get('length',None)
		self.__version = kwargs.get('version',None)

		if self.__version == None:
			raise TypeError("Parameter 'version' is not defined")
		
		if self.__message == None:
			raise TypeError("Parameter 'message' is not defined")

		if self.__message_length == None:
			raise TypeError("Parameter 'length' is not defined")

	def __stage1(self):
		r'''
			Function implements stage 1 (8.1)
		'''		

		if self.__version == "512":
			self.__h = 0
		else:
			self.__h = ZZ("00000001"*64,2)
		
		self.__length			= self.__message_length
		self.__m 	 = self.__M = self.__message
		self.__N     = 0
		self.__Sigma = 0
		
	def __stage2(self):
		r'''
			Function implements stage 2 (8.2)
		'''		
		while (self.__length >= 512):
			self.__m = self.__M & ((1<<512) - 1) # 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			#print "m={0}".format(hex(self.__m).zfill(128))
			self.__h = self.__compress(self.__N,self.__h,self.__m)
			self.__N = (self.__N + 512) % 2^512 # & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			self.__Sigma = (self.__Sigma + self.__m) % 2^512 # &
			self.__M >>= 512
			self.__length -= 512

	def __stage3(self):
		r'''
			Function implements stage 3 (8.3)
		'''
		self.__m = self.__M ^^ (1 << self.__length)
		#print "m={0}".format(hex(self.__m).zfill(128))
		self.__h = self.__compress(self.__N,self.__h,self.__m)
		#print "h={0}".format(hex(self.__h).zfill(128))
		self.__N = (self.__N + self.__length) % 2^512 # &
		#print "N={0}".format(hex(self.__N).zfill(128))
		self.__Sigma = (self.__Sigma + self.__m) % 2^512 # &
		#print "Sigma={0}".format(hex(self.__Sigma).zfill(128))
		self.__h = self.__compress(0,self.__h,self.__N)
		#print "h={0}".format(hex(self.__h).zfill(128))
		self.__h = self.__compress(0,self.__h,self.__Sigma)
		#print "h={0}".format(hex(self.__h).zfill(128))

		if self.__version == "256":
			self.__h >>= 256
