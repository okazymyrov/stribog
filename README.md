## Overview

Standard GOST 34.11-2012 "Information technology. CRYPTOGRAPHIC DATA SECURITY. Hash-functions" came into the effect in 2013. The standard is based on previously published hash function Stribog.

This project includes two implementations of the hash function in C and Sage. Sage version provides additional functionality including generating of tables and test vectors for C.

Propositions, comments, speedup or other improvements are welcome for both program and description (presentation) sources.

## Authors

Oleksandr Kazymyrov: oleksandr.kazymyrov (at) ii.uib.no

### Acknowledgements

Oleksii Shevchuk for C code improvements.

## Versions

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

* [GOST R 34.11-2012 (ver.1)](https://www.tc26.ru/en/GOSTR3411-2012/ENG_GOST_R_3411-2012_v1.pdf)
* [Presentation](https://docs.google.com/open?id=0BxESDYeDaATvZy0zRkJDcDhsM0E)
* [The most recent version of Stribog (In Russian)](https://www.tc26.ru/forum/download/file.php?id=336&sid=ac66492ab050da628552094891eae073)
