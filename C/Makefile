TARGET		= stribog
CC			= gcc
CCOPT		= -O3 -Wall -g0 -fomit-frame-pointer
DEFS		= -DFULL_UNROLL #-DSELF_TESTING
INCLS		= -I./
CFLAGS		= $(CCOPT) $(DEFS) $(INCLS)
LDFLAGS		= 
LIBS		= 
NETLIBS		= 
FILES		= $(shell ls ./*.c)
TABLE		= 1

ifeq ($(TABLE),1)
	FILES += ./table/stribog.c
else
	FILES += ./standard/stribog.c
endif

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
