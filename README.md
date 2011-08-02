JavaLevelDB is java bridge to C library [leveldb](http://code.google.com/p/leveldb/).
========
LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.
That project provides jar with native libraries inside it. In order to build under certain OS use *make* command. 

Dependencies
------------ 
* leveldb sources/headers - runs svn chechout in Makefile
* swig - generate Java (JNI) interface to C++ library
* Java1.2