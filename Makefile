# This script is adapted from Brian Ripley's readme available at
# http://www.stats.ox.ac.uk/pub/Rtools/goodies/sources/README.txt

PATH32=/c/Rtools/mingw_32/bin
PATH64=/c/Rtools/mingw_64/bin

.PHONY: bzip2 libpng libz clean

all: bzip2 libpng

bzip2:
	tar xf bzip2*tar.xz
	cd bzip2*/ && \
	make clean && \
	PATH=$(PATH32):$$PATH make CFLAGS=-O2 libbz2.a && \
	touch bzip2 bzip2recover && \
	PATH=$(PATH32):$$PATH make install CFLAGS=-O2 PREFIX=/c/W32soft && \
	make clean && \
	PATH=$(PATH64):$$PATH make CFLAGS=-O2 libbz2.a && \
	touch bzip2 bzip2recover && \
	PATH=$(PATH64):$$PATH make install CFLAGS=-O2 PREFIX=/c/W64soft

# make CC=/c/x86_64-w64-mingw32-gcc AR=x86_64-w64-mingw32-ar RANLIB=x86_64-w64-mingw32-ranlib CFLAGS=-O2 libbz2.a
# touch bzip2 bzip2recover
# make install PREFIX=.../W64soft

gdal:
	./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
		--prefix=/c/W64soft CFLAGS=-O2 CXXFLAGS=-O2 --without-curl \
		--with-expat=/c/W64soft --with-odbc --without-geos --with-static-proj4 \
		--with-sqlite3=.../W64soft

#./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
#--prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --without-curl \
#--with-expat=.../W64soft --with-odbc --without-geos --with-static-proj4 \
#--with-sqlite3=.../W64soft

libpng: zlib
	tar xf libpng*tar.xz
	cd libpng*/ && \
	PATH=$(PATH32):$$PATH ./configure --enable-static --disable-shared \
	--prefix=/c/W32soft CFLAGS=-O2 CXXFLAGS=-O2 LIBS=-L/c/W32soft/lib \
	CPPFLAGS=-I/c/W32soft/include && \
	PATH=$(PATH32):$$PATH make && \
	PATH=$(PATH32):$$PATH make install

libxml2:
./configure --host=x86_64-w64-mingw32 --enable-static --disable-shared \
prefix=.../W64soft CFLAGS=-O2 CXXFLAGS=-O2 --without-python \
--with-zlib=.../W64soft --with-iconv=.../W64soft --without-lzma

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
	cd zlib*/ && \
	PATH=$(PATH64):$$PATH ./configure --static  -prefix=.../W64soft && \
	PATH=$(PATH64):$$PATH make && \
	PATH=$(PATH64):$$PATH make install && \
	make clean && \
	PATH=$(PATH32):$$PATH ./configure --static  -prefix=.../W32soft && \
	PATH=$(PATH32):$$PATH make && \
	PATH=$(PATH32):$$PATH make install
	
clean:
	rm -r bzip2*/ libpng*/ zlib*/