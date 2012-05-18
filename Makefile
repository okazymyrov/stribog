TARGET     = stribog
CC         = gcc
CCOPT      = -O3 -Wall -ggdb #-m64 #-g -E  
FOPT       = -march=native -flto -static -ftree-vectorize -fno-bounds-check
DEFS       =
INCLS      = -I./
CFLAGS     = $(CCOPT) $(DEFS) $(INCLS) $(FOPT)
LDFLAGS    = 
LIBS       = -lm -lpthread
NETLIBS    = 
FILES	   = $(shell ls ./*.c)

OBJECTS    = $(FILES:.c=.o)
CLEANFILES = $(OBJECTS) $(TARGET)

all: clean $(TARGET)

$(TARGET): $(OBJECTS)
	@$(CC) $(LDFLAGS) $(STATICFLAG) $(OBJECTS) $(LIBS) -o $(TARGET)
	@echo "Make end"

.c.o:
	@$(CC) $(CFLAGS) -c $*.c -o ./$*.o 

clean:
	@rm -f $(CLEANFILES)
	@echo "Cleaned"
