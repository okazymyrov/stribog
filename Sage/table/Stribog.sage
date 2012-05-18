#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

load Data.sage

class Stribog(SageObject):
	def __init__(self, **kwargs):
		r'''
			Fast implimenstation of hash function Stribog.
		'''
	def __compress(self,Nn,h,m):
		r'''
			Realization g_N(h,m)
		'''
		return self.__E(self.__F(h ^^ Nn),m) ^^ h ^^ m

	def __E(self,K,m):
		r'''
			Encryption procedure
		'''
		Ki    = K
		state = m ^^ Ki

		for i in xrange(12):
			state = self.__F(state)
			Ki = self.__F(Ki ^^ C[i])
			state = state ^^ Ki

		return state

	def __F(self,state):
		r'''
			Function implements S, P and L function from specification
		'''
		return_state = 0
		t = 0

		# i = 0
		t = t ^^ ( T[0][ ( state & (0xFF       ) )        ] )
		t = t ^^ ( T[1][ ( state & (0xFF <<  64) ) >>  64 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 128) ) >> 128 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 192) ) >> 192 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 256) ) >> 256 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 320) ) >> 320 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 384) ) >> 384 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 448) ) >> 448 ] )

		return_state ^^= t
		t = 0

		# i = 1
		t = t ^^ ( T[0][ ( state & (0xFF <<   8) ) >>   8 ] )
		t = t ^^ ( T[1][ ( state & (0xFF <<  72) ) >>  72 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 136) ) >> 136 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 200) ) >> 200 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 264) ) >> 264 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 328) ) >> 328 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 392) ) >> 392 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 456) ) >> 456 ] )

		return_state ^^= (t << 64)
		t = 0

		# i = 2
		t = t ^^ ( T[0][ ( state & (0xFF <<  16) ) >>  16 ] )
		t = t ^^ ( T[1][ ( state & (0xFF <<  80) ) >>  80 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 144) ) >> 144 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 208) ) >> 208 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 272) ) >> 272 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 336) ) >> 336 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 400) ) >> 400 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 464) ) >> 464 ] )

		return_state ^^= (t << 128)
		t = 0

		# i = 3
		t = t ^^ ( T[0][ ( state & (0xFF <<  24) ) >>  24 ] )
		t = t ^^ ( T[1][ ( state & (0xFF <<  88) ) >>  88 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 152) ) >> 152 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 216) ) >> 216 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 280) ) >> 280 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 344) ) >> 344 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 408) ) >> 408 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 472) ) >> 472 ] )

		return_state ^^= (t << 192)
		t = 0

		# i = 4
		t = t ^^ ( T[0][ ( state & (0xFF <<  32) ) >>  32 ] )
		t = t ^^ ( T[1][ ( state & (0xFF <<  96) ) >>  96 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 160) ) >> 160 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 224) ) >> 224 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 288) ) >> 288 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 352) ) >> 352 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 416) ) >> 416 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 480) ) >> 480 ] )

		return_state ^^= (t << 256)
		t = 0

		# i = 5
		t = t ^^ ( T[0][ ( state & (0xFF <<  40) ) >>  40 ] )
		t = t ^^ ( T[1][ ( state & (0xFF << 104) ) >> 104 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 168) ) >> 168 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 232) ) >> 232 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 296) ) >> 296 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 360) ) >> 360 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 424) ) >> 424 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 488) ) >> 488 ] )

		return_state ^^= (t << 320)
		t = 0

		# i = 6
		t = t ^^ ( T[0][ ( state & (0xFF <<  48) ) >>  48 ] )
		t = t ^^ ( T[1][ ( state & (0xFF << 112) ) >> 112 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 176) ) >> 176 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 240) ) >> 240 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 304) ) >> 304 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 368) ) >> 368 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 432) ) >> 432 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 496) ) >> 496 ] )

		return_state ^^= (t << 384)
		t = 0

		# i = 7
		t = t ^^ ( T[0][ ( state & (0xFF <<  56) ) >>  56 ] )
		t = t ^^ ( T[1][ ( state & (0xFF << 120) ) >> 120 ] )
		t = t ^^ ( T[2][ ( state & (0xFF << 184) ) >> 184 ] )
		t = t ^^ ( T[3][ ( state & (0xFF << 248) ) >> 248 ] )
		t = t ^^ ( T[4][ ( state & (0xFF << 312) ) >> 312 ] )
		t = t ^^ ( T[5][ ( state & (0xFF << 376) ) >> 376 ] )
		t = t ^^ ( T[6][ ( state & (0xFF << 440) ) >> 440 ] )
		t = t ^^ ( T[7][ ( state & (0xFF << 504) ) >> 504 ] )

		return_state ^^= (t << 448)

		return return_state

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
		self.__m 	 			= self.__M 		= self.__message
		self.__N     			= self.__Sigma 	= 0
		
	def __stage2(self):
		r'''
			Function implements stage 2 (8.2)
		'''		
		while (self.__length >= 512):
			self.__m = self.__M & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			self.__h = self.__compress(self.__N,self.__h,self.__m)
			self.__N = (self.__N + 512) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			self.__Sigma = (self.__Sigma + self.__m) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			self.__M >>= 512
			self.__length -= 512

	def __stage3(self):
		r'''
			Function implements stage 3 (8.3)
		'''
		self.__m = self.__M ^^ (1 << self.__length)
		
		self.__h = self.__compress(self.__N,self.__h,self.__m)
		
		self.__N = (self.__N + self.__length) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		self.__Sigma = (self.__Sigma + self.__m) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
		
		self.__h = self.__compress(0,self.__h,self.__N)
		self.__h = self.__compress(0,self.__h,self.__Sigma)

		if self.__version == "256":
			self.__h >>= 256
