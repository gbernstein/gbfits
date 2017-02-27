# These should come from environment:
# CXX
# OPTFLAGS

# CFITSIO_DIR

# It is assumed that the utilities/ directory is at ../utilities 

export CXX
export OPTFLAGS

CXXFLAGS := $(OPTFLAGS)

LIBS := -lm

# Collect the includes and libraries we need
ifdef CFITSIO_DIR
CXXFLAGS += -I $(CFITSIO_DIR)/include
LIBS += -L $(CFITSIO_DIR)/lib -lcfitsio
else
$(error Require CFITSIO_DIR in environment)
endif

# Collect the includes and libraries we need
ifdef GBUTIL_DIR
CXXFLAGS += -I $(GBUTIL_DIR)
else
$(error Require GBUTIL_DIR in environment)
endif

# External directories where we'll need to clean/build dependents
EXTDIRS = $(GBUTIL_DIR)

OBJ = FITS.o Header.o Hdu.o FitsTable.o FTable.o FTableExpression.o Image.o FitsImage.o

EXTOBJ := $(GBUTIL_DIR)/StringStuff.o $(GBUTIL_DIR)/Expressions.o

all: $(OBJ)

###############################################################
## Standard stuff:
###############################################################

exts:
	for dir in $(EXTDIRS); do (cd $$dir && $(MAKE)); done

local-depend:
	$(CXX) $(CXXFLAGS) -MM $(SRC) > .$@

depend: local-depend
	for dir in $(EXTDIRS); do (cd $$dir && $(MAKE) depend); done

local-clean:
	rm -f *.o *~ core .depend tests/*.o

clean: local-clean
	for dir in $(EXTDIRS); do (cd $$dir && $(MAKE) clean); done

ifeq (.depend, $(wildcard .depend))
include .depend
endif

export

.PHONY: all install dist depend clean 
