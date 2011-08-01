rm -rv src/com/anvisics/jleveldb/ext
mkdir src/com/anvisics/jleveldb/ext
swig -c++ -java -package com.anvisics.jleveldb.ext -outdir src/com/anvisics/jleveldb/ext -o build/db_wrap.cpp db.i;
g++ -c -fpic build/db_wrap.cpp -I/usr/lib/jvm/java-6-openjdk/include/ -Ibuild/leveldb/include/ -o build/obj/db_wrap.o;
g++ -shared build/obj/*.o -o src/linux-x86.lib;

