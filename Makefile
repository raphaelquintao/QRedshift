SRC=src
IDIR=src
CC=cc
#CFLAGS=-I$(IDIR)

ODIR=build

LDIR=../lib

MAIN=main.c

#LIBS=-lm
#
#_DEPS = hellomake.h
#DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))
#
#_OBJ = hellomake.o hellofunc.o
#OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))
#
#
#$(ODIR)/%.o: %.c $(DEPS)
#	$(CC) -c -o $@ $< $(CFLAGS)
#
#hellomake: $(OBJ)
#	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)
#
#.PHONY: clean
#
#clean:
#	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
##	mkdir -p $(ODIR)
#	echo $@


%.o: $(SRC)/%.c
	$(CC) -c -o $@ $<

qredshift: LICENSE.txt
	@echo "HELLO MAKEFILE"
	@#cat $<



# Phony target to trigger the rule
#.PHONY: all
#all: $(SRC)/main.c