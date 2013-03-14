#  Created on: May 5, 2012
#		Author: Oleksandr Kazymyrov <oleksandr.kazymyrov@uib.no>

load Data.sage

class Stribog_2_8(SageObject):
	def __init__(self, **kwargs):
		r'''
			Implementation of hash function Stribog over GF(2^8)
		'''
		
		self._K = GF(2^8,'a',modulus=ZZ['x']('x^8+x^6+x^5+x^4+1'))
		self._P = PolynomialRing(self._K,'x')

		self._Sbox = self._P("a^137*x^254 + a^80*x^253 + a^168*x^252 + a^247*x^251 + a^26*x^250 + a^88*x^249 + a^19*x^248 + a^67*x^247 + a^226*x^246 + a^221*x^245 + \
			a^56*x^244 + a^232*x^243 + a^163*x^242 + a^20*x^241 + a^230*x^240 + a^58*x^239 + a^225*x^238 + a^15*x^237 + a^118*x^236 + a^4*x^235 + a^5*x^234 + a^28*x^233 + \
			a^233*x^232 + a^76*x^231 + a^113*x^230 + a^39*x^229 + a^103*x^228 + a^50*x^227 + a^154*x^226 + a^108*x^225 + a^136*x^224 + a^164*x^223 + a^226*x^222 + \
			a^244*x^221 + a^173*x^220 + a^61*x^219 + a^59*x^218 + a^192*x^217 + a^181*x^216 + a^53*x^215 + a^5*x^214 + a^148*x^213 + a^181*x^212 + a^52*x^211 + \
			a^186*x^210 + a^237*x^209 + a^20*x^208 + a^174*x^207 + a^6*x^206 + a^84*x^205 + a^69*x^204 + a^159*x^203 + a^153*x^202 + a^31*x^201 + a^125*x^200 + \
			a^208*x^199 + a^92*x^198 + a^71*x^197 + a^150*x^196 + a^220*x^195 + a^51*x^194 + a^202*x^193 + a^113*x^192 + a^31*x^191 + a^80*x^190 + a^176*x^189 + \
			a^18*x^188 + a^26*x^187 + a^136*x^186 + a^162*x^185 + a^219*x^184 + a^177*x^183 + a^47*x^182 + a^82*x^181 + a^234*x^180 + a^79*x^179 + a^93*x^178 + \
			a^118*x^177 + a^26*x^176 + a^155*x^175 + a^131*x^174 + a^232*x^173 + a^249*x^172 + a^241*x^171 + a^5*x^170 + a^197*x^169 + a^228*x^168 + a^69*x^167 + \
			a^133*x^166 + a^194*x^165 + a^34*x^164 + a^83*x^163 + a^114*x^162 + a^185*x^161 + a^81*x^160 + a^216*x^159 + a^75*x^158 + a^16*x^157 + a^91*x^156 + \
			a^241*x^155 + a^156*x^154 + a^183*x^153 + a^251*x^152 + a^227*x^151 + a^89*x^150 + a^80*x^149 + a^81*x^148 + a^26*x^147 + a^181*x^146 + a^101*x^145 + \
			a^173*x^144 + a^206*x^143 + a^85*x^142 + a^196*x^141 + a^43*x^140 + a^95*x^139 + a^141*x^138 + a^77*x^137 + a^117*x^136 + a^87*x^135 + a^253*x^134 + \
			a^3*x^133 + a^218*x^132 + a^7*x^131 + a^147*x^130 + a^162*x^129 + a^22*x^128 + a^101*x^127 + a^46*x^126 + a^244*x^125 + a^109*x^124 + a^187*x^123 + \
			a^52*x^122 + a^35*x^121 + a^171*x^120 + a^179*x^119 + a^126*x^118 + a^11*x^117 + a^225*x^116 + a^27*x^115 + a^126*x^114 + a^19*x^113 + a^143*x^112 + \
			a^151*x^111 + a^43*x^110 + a^145*x^109 + a^234*x^108 + a^70*x^107 + a^175*x^106 + a^27*x^105 + a^179*x^104 + a^14*x^103 + a^123*x^102 + a^11*x^101 + \
			a^173*x^100 + a^114*x^99 + a^18*x^98 + a^40*x^97 + a*x^96 + a^51*x^95 + a^251*x^94 + a^2*x^93 + a^248*x^92 + a^241*x^91 + a^14*x^90 + a^72*x^89 + \
			a^26*x^88 + a^87*x^87 + a^229*x^86 + a^234*x^85 + a^5*x^84 + a^131*x^83 + a^9*x^82 + a^106*x^81 + a^186*x^80 + a^36*x^79 + a^248*x^78 + a^115*x^77 + \
			a^133*x^76 + a^58*x^75 + a^111*x^74 + a^236*x^73 + a^58*x^72 + a^55*x^71 + a^88*x^70 + a^109*x^69 + a^95*x^68 + a^107*x^67 + a^211*x^66 + a^129*x^65 + \
			a^25*x^64 + a^225*x^63 + a^253*x^62 + a^45*x^61 + a^253*x^60 + a^152*x^59 + a^204*x^58 + a^156*x^57 + a^51*x^56 + a^201*x^55 + a^218*x^54 + a^14*x^53 + \
			a^12*x^52 + a^61*x^51 + a^26*x^50 + a^253*x^49 + a^159*x^48 + a^91*x^47 + a^167*x^46 + a^141*x^45 + a^80*x^44 + a^189*x^43 + a^240*x^42 + a^210*x^41 + \
			a^79*x^40 + a^252*x^39 + a^30*x^38 + a^202*x^37 + a^166*x^36 + a^64*x^35 + a^137*x^34 + a^102*x^33 + a^37*x^32 + a^147*x^31 + a^20*x^30 + a^46*x^29 + \
			a^173*x^28 + a^36*x^27 + a^205*x^26 + a^166*x^25 + a^184*x^24 + a^133*x^23 + a^121*x^22 + a^16*x^21 + a^222*x^20 + a^90*x^19 + a^38*x^18 + a^173*x^17 + \
			a^115*x^16 + a^92*x^15 + a^54*x^14 + a^240*x^13 + a^106*x^12 + a^230*x^11 + a^238*x^10 + a^223*x^9 + a^170*x^8 + a^63*x^7 + a^121*x^6 + a^129*x^5 + \
			a^19*x^4 + a^51*x^3 + a^245*x^2 + a^64*x + a^94")

		M = matrix(ZZ,8,[
			[0x71,0x05,0x09,0xB9,0x61,0xA2,0x27,0x0E],
			[0x04,0x88,0x5B,0xB2,0xE4,0x36,0x5F,0x65],
			[0x5F,0xCB,0xAD,0x0F,0xBA,0x2C,0x04,0xA5],
			[0xE5,0x01,0x54,0xBA,0x0F,0x11,0x2A,0x76],
			[0xD4,0x81,0x1C,0xFA,0x39,0x5E,0x15,0x24],
			[0x05,0x71,0x5E,0x66,0x17,0x1C,0xD0,0x02],
			[0x2D,0xF1,0xE7,0x28,0x55,0xA0,0x4C,0x9A],
			[0x0E,0x02,0xF6,0x8A,0x15,0x9D,0x39,0x71]
		])
		
		self._G = matrix(self._K,8)

		for i in xrange(8):
			for j in xrange(8):
				self._G[i,j] = self._K(M[i,j].digits(2))

	def __compress(self,Nn,h,m):
		r'''
			Implementation of g_N(h,m)
		'''
		h = ZZ(list(reversed(h.digits(2,padto=512))),2)
		m = ZZ(list(reversed(m.digits(2,padto=512))),2)
		Nn = ZZ(list(reversed(Nn.digits(2,padto=512))),2)

		K = h ^^ Nn

		#K = ZZ(list(reversed(K.digits(2,padto=512))),2)

		#print "K={0}".format(hex(K).zfill(128))
		K = self.__S(K)
		#print "S={0}".format(hex(K).zfill(128))
		K = self.__P(K)
		#print "P={0}".format(hex(K).zfill(128))
		K = self.__L(K)
		#print "L={0}".format(hex(K).zfill(128))

		#print "m={0}".format(hex(m).zfill(128))		
		
		#exit(0)

		t = self.__E(K,m) ^^ h ^^ m

		t = ZZ(list(reversed(t.digits(2,padto=512))),2)

		return t

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
			Implementation of stages 1, 2 and 3
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
			Generate K_{i+1} key
		'''
		Ki = K ^^ C_8[i]
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
			Multiplication by matrix G over GF(2^8)
		'''
		T = matrix(self._K,8,[self._K.fetch_int(i) for i in ZZ(state).digits(2^8,padto=64)])
		T = T.transpose()

		T = self._G*T

		T = T.transpose()
		T = ZZ([i.integer_representation() for i in T.list()],2^8)
		
		return T

	def __P(self,state):
		r'''
			Provide matrix transposition
		'''
		T = matrix(ZZ,8,ZZ(state).digits(2^8,padto=64))
		T = T.transpose() # 3 last strings is tranformation to state like in AES

		T = T.transpose() # Real transformation

		T = T.transpose() # back transformation to state
		T = ZZ([i for i in T.list()],2^8)
		
		return T
		
	def __S(self,state):
		r'''
			SubBytes procedure (very slow)
		'''	
		t = state
		t = t.digits(base=2^8,padto=64)
		
		t = [(self._Sbox.subs(self._K.fetch_int(g))).integer_representation() for g in t]

		t = ZZ(t,2^8)

		return t
		
	def selfTesting(self):
		r'''
			Testing the class using data from the specification
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
				message - a bit string for hashing (must be integer)
				length  - length of 'message' in bits
				version - length of the hash value. It can takes values "256" and "512".
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
			Implementation of stage 1 (8.1)
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
			Implementation of stage 2 (8.2)
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
			Implementation of stage 3 (8.3)
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
