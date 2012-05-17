TARGET     = stribog
CC         = gcc
CCOPT      = -O3 -Wall -funroll-all-loops -fmerge-all-constants -fomit-frame-pointer #-m64 #-g -E  
DEFS       =
INCLS      = -I./
CFLAGS     = $(CCOPT) $(DEFS) $(INCLS)
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
