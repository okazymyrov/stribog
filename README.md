## Overview

Standard GOST 34.11-2012 "Information technology. CRYPTOGRAPHIC DATA SECURITY. Hash-functions" came into the effect in 2013. The standard is based on previously published hash function Stribog.

This project includes two implementations of the hash function in C and Sage. Sage version provides additional functionality including generating of tables and test vectors for C.

Propositions, comments, speedup or other improvements are welcome for both program and description (presentation) sources.

## Authors

Oleksandr Kazymyrov: oleksandr.kazymyrov (at) ii.uib.no

### Acknowledgements

Oleksii Shevchuk and Dmitry Olshansky for C code improvements.

## Comments

According to [an example](http://ru.wikipedia.org/wiki/%D0%93%D0%9E%D0%A1%D0%A2_%D0%A0_34.11-94#.D0.9F.D0.BE.D0.B4.D1.80.D0.BE.D0.B1.D0.BD.D1.8B.D0.B9_.D0.BF.D1.80.D0.B8.D0.BC.D0.B5.D1.80_.D0.B8.D0.B7_.D1.81.D1.82.D0.B0.D0.BD.D0.B4.D0.B0.D1.80.D1.82.D0.B0), bytes stored on a hard drive or transmited to a channel have [Little-endian](http://en.wikipedia.org/wiki/Little-endian#Little-endian) notation for GOST R 34.11-94. The same notation has to be used for GOST R 34.11-2012 (it is not regulated). That is, the message from Appendix 2.2

> M<sub>2</sub> = 0xFBE2E5F0EEE3C820FBEAFAEBEF20FFFBF0E1E0F0F520E0ED20E8ECE0EBE5F0 \\
F2F120FFF0EEEC20F120FAF2FEE5E2202CE8F6F3EDE220E8E6EEE1E8F0F2D1202CE8F0F2E5E220E5D1

on the disk will have from

> 0xD1E520E2E5F2F0E82C20D1F2F0E8E1EEE6E820E2EDF3F6E82C20E2E5FEF2FA20F120ECEEF0FF20F1F2 \\
F0E5EBE0ECE820EDE020F5F0E0E1F0FBFF20EFEBFAEAFB20C8E3EEF0E5E2FB

Moreover, decoding the last string using WIN-1251 gives "Се ветри, Стрибожи внуци, веютъ с моря стрелами на храбрыя плъкы Игоревы", which is a phrase from ["The Tale of Igor's Campaign"](http://en.wikipedia.org/wiki/The_Tale_of_Igor%27s_Campaign).

Therefore, the current implementation is the proof of concept with representation given in the standard. For real applications the code must be changed to correct endianness (depends on your platform).

## Versions

### Version 1.1.2

C

* speeded up F transformation (Dmitry Olshansky)

### Version 1.1.1

Sage

* Added support of Stribog over GF(2^8)


### Version 1.1

C

* Cross platform implementation checked on Ubuntu 12.10 (gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3), Windows 7 (Visual Studio 2012), OS X 10.8.2 (i686-apple-darwin11-llvm-gcc-4.2 (GCC) 4.2.1)
* Increased performance of table C implementation by 1.5 times
* Fixed bugs related to special lengths of messages
* Added FULL_UNROLL and SELF_TESTING options

Sage

* Added function to generate "test_data.h" file for C
* Changed the table generation function for speedup improvement of C version
* Deleted table implementation (unnecessary)
* Cleaning up code

### Version 1.0

C

* Added standard (human-readable) and table implementations
* Linux oriented performance test and code 
* Orientation on little-endian platforms

Sage:

* Added standard and table implementations
* Class Tools provides additional functionality (i.e. matrix multiplication of L, table generation and so on)

## References

* [GOST R 34.11-2012 (Draft)](http://tk26.ru/en/GOSTR3411-2012/GOST_R_34_11-2012_eng.pdf)
* [Presentation](https://docs.google.com/open?id=0BxESDYeDaATvZy0zRkJDcDhsM0E)
* [The most recent version of Stribog (In Russian)](http://specremont.su/pdf/gost_34_11_2012.pdf)
* [MDS matrix generator](https://github.com/okazymyrov/MDS)
