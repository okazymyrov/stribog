TARGET     = stribog
CC         = gcc
CCOPT      = -O3 -Wall -march=native  
DEFS       =
INCLS      = -I./
CFLAGS     = $(CCOPT) $(DEFS) $(INCLS)
LDFLAGS    = 
LIBS       = #-lm -lpthread
NETLIBS    = 
FILES	   = $(shell ls ./*.c)

TABLE	   = 1
ifdef TABLE
	FILES += ./table/stribog.c
else
	FILES += ./etalon/stribog.c
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
