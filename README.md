JavaLevelDB is java bridge to C++ library [leveldb](http://code.google.com/p/leveldb/).
========
LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.
That project provides tiny access to library making transparent access to C++ [classes](http://code.google.com/p/leveldb/source/browse/#svn%2Ftrunk%2Finclude%2Fleveldb) through Java facade.

How to build
--------------------
Checkout the project and run in command line : 
        'make' - checkout leveldb project from svn, compile it and build ready to use jar.

Build is only tested under Linux. 
Possible problems : 

* No internet connection to checkout leveldb from googlecode
* [leveldb](http://code.google.com/p/leveldb/source/browse/trunk/build_detect_platform) can not be built under certain environment (under Cygwin in Windows)
* JAVA_HOME variable is not defined
* [swig](http://www.swig.org/) is not installed

How to use
-----------

To do put example.

What is not supported
--------------------
There are some things not supported from C++ [API](http://code.google.com/p/leveldb/source/browse/#svn%2Ftrunk%2Finclude%2Fleveldb) : 
* [TableBuilder](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/table_builder.h) and [Table](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/table.h) - important enough to be implemented.
* [Comparator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/comparator.h) - important enough (callback)

Is it really needed ?

* [Cache](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/cache.h) - own implementation of cache 
* [Environment](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/env.h) - own implementation of RandomAccessFile, SequentialFile,...
* [Cleanup Function of Iterator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/iterator.h)
* [Options +](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/options.h) - requires additional entity to be implemented such as Snapshot, Environment, Logger. 
* [WriteBatch Iterator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/write_batch.h) - iterate over entities to be writen

Something missed?

Contribution
--------------------
Please feel free to make for and provide your pull requests :)


Additional
--------------------



