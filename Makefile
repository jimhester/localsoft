# This script is adapted from Brian Ripley's readme available at
# http://www.stats.ox.ac.uk/pub/Rtools/goodies/sources/README.txt

PATH32=/c/Rtools/mingw_32/bin
PATH64=/c/Rtools/mingw_64/bin

PRE32=C:/W32soft
PRE64=C:/W64soft

zlib=$(PRE32)/lib/libz.a $(PRE64)/lib/libz.a
bzip2=$(PRE32)/lib/libbz2.a $(PRE64)/lib/libbz2.a
libiconf=$(PRE32)/lib/libiconf.a $(PRE64)/lib/libiconf.a
#libpng=$(PRE32)

all: bzip2 libpng

bzip2:
	tar xf bzip2*tar.xz
	cd bzip2*/ && \
	make clean && \
	PATH=$(PATH32):$$PATH make CFLAGS=-O2 libbz2.a && \
	touch bzip2 bzip2recover && \
	PATH=$(PATH32):$$PATH make install CFLAGS=-O2 PREFIX=$(PRE32) && \
	make clean && \
	PATH=$(PATH64):$$PATH make CFLAGS=-O2 libbz2.a && \
	touch bzip2 bzip2recover && \
	PATH=$(PATH64):$$PATH make install CFLAGS=-O2 PREFIX=$(PRE64)

gdal:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
		--prefix=$(PRE64) CFLAGS=-O2 CXXFLAGS=-O2 --without-curl \
		--with-expat=$(PRE64) --with-odbc --without-geos --with-static-proj4 \
		--with-sqlite3=.../W64soft

#./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
#--prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --without-curl \
#--with-expat=.../W64soft --with-odbc --without-geos --with-static-proj4 \
#--with-sqlite3=.../W64soft

libpng: zlib
	tar xf libpng*tar.xz
	cd libpng*/ && \
	PATH=$(PATH64):$$PATH ./configure --enable-static --disable-shared \
	--prefix=$(PRE64) CFLAGS=-O2 CXXFLAGS=-O2 LIBS=-L$(PRE64)/lib CPPFLAGS=-I$(PRE64)/include && \
	PATH=$(PATH64):$$PATH make
	#&& \
	PATH=$(PATH32):$$PATH make install && \
	make clean && \
	PATH=$(PATH64):$$PATH ./configure --enable-static --disable-shared \
	--prefix=$(PRE64) && \
	PATH=$(PATH64):$$PATH make && \
	PATH=$(PATH64):$$PATH make install

libxml2: zlib
	tar xf libxml2*tar.xz
	cd libxml2*/ && \
	PATH=$(PATH64):$$PATH ./configure --enable-static --disable-shared \
    --prefix=$(PRE64) CFLAGS=-O2 CXXFLAGS=-O2 --without-python \
    --with-zlib=$(PRE64) --without-lzma

mpfr:
./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
-prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --with-gmp=.../W64soft

netcdf:
./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
-prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --disable-netcdf-4 --disable-dap

or for use with ncdf4:
./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
-prefix=.../W64soft CFLAGS=-O2  CXXFLAGS=-O2 \
--disable-dynamic-loading --disable-dap \
CPPFLAGS="-I.../h5-libwin/include/hdf5 -I.../h5-libwin/include/hdf5_hl 
  -I.../h5-libwin/include/cmakeconf" \
LDFLAGS=-L.../h5-libwin/lib/x64

pcre:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
		-prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 \
		--enable-utf --enable-unicode-properties --enable-jit --disable-cpp

proj:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
		-prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --without-mutex

tiff:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
	--disable-lzma -prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 \
	CPPFLAGS=-I.../W64soft/include LIBS=-L.../W64soft/lib

udunits2:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
	-prefix=.../W64soft CFLAGS=-O2  CXXFLAGS=-O2 \
	LDFLAGS=-L.../W64soft/lib CPPFLAGS=-I.../W64soft/include

zlib:
	tar xf zlib*tar.xz
	cd zlib*/ && \
	patch < ../zlib.patch && \
	PATH=$(PATH32):$$PATH ./configure --static --prefix=$(PRE32) && \
	PATH=$(PATH32):$$PATH make && \
	PATH=$(PATH32):$$PATH make install && \
	make clean && \
	PATH=$(PATH64):$$PATH ./configure --static --prefix=$(PRE64) && \
	PATH=$(PATH64):$$PATH make && \
	PATH=$(PATH64):$$PATH make install

iconv:
	
clean:
	rm -rf bzip2*/ libpng*/ zlib*/ $(PRE32) $(PRE64)
	
$(PRE32)/lib/%.a:
	tar xf $**tar.xz
	cd $**/ && \
	PATH=$(PATH32):$$PATH ./configure --build i686-pc-mingw32 --enable-static --disable-shared \
	  --prefix=$(PRE32) CFLAGS=-O2 CXXFLAGS=-O2 MAKE=/c/Rtools/bin/make && \
	PATH=$(PATH32):$$PATH make && \
	PATH=$(PATH32):$$PATH make install
	
$(PRE64)/lib/%.a:
	tar xf $**tar.xz
	cd $**/ && \
	PATH=$(PATH64):$$PATH ./configure --build x86_64-pc-mingw64 --enable-static --disable-shared \
	  --prefix=$(PRE64) CFLAGS=-O2 CXXFLAGS=-O2 MAKE=/c/Rtools/bin/make && \
	PATH=$(PATH64):$$PATH make && \
	PATH=$(PATH64):$$PATH make install