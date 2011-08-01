# Makefile for the native LEVEL DB Driver
#
# No auto-goop. Just try typing 'make'. You should get two interesting files:
#     build/TARGET_OS/LIBNAME
#     build/jleveldb-vXXX.jar
#
# To combine these, type:
# 	  cd build
# 	  mv LIBNAME linux-x86.lib (or win-x86.lib, freebsd-ppc.lib, mac.lib, etc)
#     java uf jleveldb-vXXX.jar linux-x86.lib
#
# The first is the native library, the second is the java support files.
# Generating the more complete jleveldb-vXXX.jar requires building the
# NestedVM source, which requires running a Linux machine, and looking at
# the other make files.
#

include Makefile.vars

default: test

test: native $(test_classes)
	$(JAVA) -Djava.library.path=build/$(target) \
	    -cp "build/$(sqlitejdbc)-native.jar$(sep)build$(sep)$(libjunit)" \
	    org.junit.runner.JUnitCore $(tests)

native: build/$(jleveldb)-native.jar build/$(target)/$(LIBNAME)

build/$(jleveldb)-native.jar: $(java_classes)
	cd build && jar cf $(jleveldb)-native.jar $(java_classlist)

# build/$(leveldb)-$(target)
build/$(target)/$(LIBNAME): build/$(leveldb)-$(target)/libleveldb.a build/com/anvisics/jleveldb/NativeLevelDB.class
	@mkdir -p build/$(target)
	$(JAVAH) -classpath build -jni -o build/NativeLevelDB.h com.anvisics.jleveldb.NativeLevelDB
	$(CC) $(CFLAGS) -c -o build/$(target)/NativeLevelDB.o \
		src/com/anvisics/jleveldb/NativeLevelDB.c
	$(CC) $(CFLAGS) $(LINKFLAGS) -o build/$(target)/$(LIBNAME) \
		build/$(target)/NativeLevelDB.o build/$(leveldb)-$(target)/libleveldb.a:
	$(STRIP) build/$(target)/$(LIBNAME)


build/$(leveldb)-$(target)/libleveldb.a:
	@mkdir -p build/$(leveldb)-$(target)
	cp build/$(leveldb)/libleveldb.a build/$(leveldb)-$(target)/libleveldb.a
  

build/com/%.class: src/com/%.java
	@mkdir -p build
	$(JAVAC) -source 1.2 -target 1.2 -sourcepath src -d build $<

build/test/%.class: src/test/%.java
	@mkdir -p build
	$(JAVAC) -target 1.5 -classpath "build$(sep)$(libjunit)" \
	    -sourcepath src/test -d build $<

clean:
	rm -rf build dist
