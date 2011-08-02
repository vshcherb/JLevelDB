# Makefile for the native LEVEL DB Driver
#
# No auto-goop. Just try typing 'make'. You should get two interesting files:
#     build/TARGET_OS/LIBNAME
#     build/jleveldb-vXXX.jar
#
# To combine these, type:
# 	  cd build
# 	  mv LIBNAME jleveldb-linux-x86.lib (or jleveldb-win-x86.lib, jleveldb-freebsd-ppc.lib, jleveldb-mac.lib, etc)
#     java uf jleveldb-vXXX.jar linux-x86.lib
#
# The first is the native library, the second is the java support files.
# Generating the more complete jleveldb-vXXX.jar requires building the
# NestedVM source, which requires running a Linux machine, and looking at
# the other make files.
#

include Makefile.vars

default : native

native : build/$(LIBNAME) build/$(jleveldb).jar

build/$(LIBNAME) : build/obj build/obj/db_wrap.o
	$(CC) $(LINKFLAGS) build/obj/*.o -o build/$(LIBNAME)
	cp build/$(LIBNAME) src/

build/obj : build/$(leveldb)/Makefile
	cd build/$(leveldb) && $(MAKE) -f Makefile
	mkdir build/obj 
	cd build/obj && ar -x ../$(leveldb)/libleveldb.a 

build/$(leveldb)/Makefile :
	svn checkout http://leveldb.googlecode.com/svn/trunk/ build/$(leveldb)

build/obj/db_wrap.o : build/db_wrap.cpp
	$(CC) $(CFLAGS) -Ibuild/leveldb/include/ build/db_wrap.cpp -o build/obj/db_wrap.o; 
	
build/db_wrap.cpp : db.i
	rm -rf src/com/anvisics/jleveldb/ext
	mkdir src/com/anvisics/jleveldb/ext
	swig -c++ -java -package com.anvisics.jleveldb.ext -outdir src/com/anvisics/jleveldb/ext -o build/db_wrap.cpp db.i;
	
build/$(jleveldb).jar: $(java_classes) build/$(LIBNAME)
	cd build && jar cf $(jleveldb).jar $(java_classlist) $(LIBNAME)


build/com/%.class: src/com/%.java
	@mkdir -p build
	$(JAVAC) -source 1.2 -target 1.2 -sourcepath src -d build $<

build/test/%.class: src/test/%.java
	@mkdir -p build
	$(JAVAC) -target 1.5 -classpath "build$(sep)$(libjunit)" \
	    -sourcepath src/test -d build $<

clean:
	rm -rf build

## Example	
## build/$(target)/$(LIBNAME): build/$(leveldb)-$(target)/libleveldb.a build/com/anvisics/jleveldb/NativeLevelDB.class
#	@mkdir -p build/$(target)
#	$(JAVAH) -classpath build -jni -o build/NativeLevelDB.h com.anvisics.jleveldb.NativeLevelDB
#	$(CC) $(CFLAGS) -c -o build/$(target)/NativeLevelDB.o \
#		src/com/anvisics/jleveldb/NativeLevelDB.c
#	$(CC) $(CFLAGS) $(LINKFLAGS) -o build/$(target)/$(LIBNAME) \
#		build/$(target)/NativeLevelDB.o build/$(leveldb)-$(target)/libleveldb.a:
#	$(STRIP) build/$(target)/$(LIBNAME)

	
