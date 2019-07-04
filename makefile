.PHONY: all clean

CC          = gcc
LD          = gcc

SHELL=bash

OBJDIR := obj

DVBCSAINC 	:= libdvbcsa/dvbcsa
DVBCSALIB 	:= $(DVBCSAINC)/libdvbcsa.a

CFLAGS      =  -w -I $(DVBCSAINC) -O3  -flto -march=znver1  -g -fopenmp -fopenmp-simd -fipa-pta 

obj/%.o : %.c | $(OBJDIR)
	@if [ "$<" == "aycwabtu_main.c" ] ; then (echo -n "#define GITSHA1 \"`git rev-parse --short=16 HEAD`\"") >aycwabtu_version.h; echo "aycwabtu_version.h written"; fi;
	$(CC) -c -g -MD $(CFLAGS) -o obj/$*.o $<

ayc_src = \
	aycwabtu_main.c             \
	aycwabtu_bs_algo.c          \
	aycwabtu_bs_block.c         \
	aycwabtu_bs_block_ab.c      \
	aycwabtu_bs_sse2.c     		  \
	aycwabtu_bs_avx.c     		  \
	aycwabtu_bs_stream.c        \
	aycwabtu_bs_uint32.c	      \
	aycwabtu_ts.c               \
	libdvbcsa/dvbcsa_algo.c     \
	libdvbcsa/dvbcsa_block.c    \
	libdvbcsa/dvbcsa_key.c      \
	libdvbcsa/dvbcsa_stream.c

tsgen_src = tsgen.c

ayc_obj = $(ayc_src:%.c=obj/%.o)
tsgen_obj = $(tsgen_src:%.c=obj/%.o)

all: aycwabtu
   

aycwabtu: $(ayc_obj) 
	$(LD) -g -O3    -fopenmp -flto -fipa-pta -o $@ $(ayc_obj) 
	@echo $@ created

tsgen: $(tsgen_obj) $(DVBCSALIB)
	$(LD) -g -o $@ $(tsgen_obj) -static -L. -ldvbcsa/dvbcsa/libdvbcsa
	@echo $@ created


test: aycwabtu tsgen always
	cd test && ./testframe.sh | tee testframe.log

always:

# pull in dependency info for *existing* .o files
-include $(ayc_obj:.o=.d)
-include $(tsgen_obj:.o=.d)

$(ayc_obj) $(tsgen_obj) : makefile

$(OBJDIR):
	mkdir $(OBJDIR)
	mkdir $(OBJDIR)/libdvbcsa

clean:
	@rm -rf aycwabtu tsgen aycwabtu.exe tsgen.exe obj
	@make -s --directory=libdvbcsa clean

