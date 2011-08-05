JavaLevelDB is java bridge to C library [leveldb](http://code.google.com/p/leveldb/).
========
LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.
That project provides tiny access to library making transparent access to C++ [classes](http://code.google.com/p/leveldb/source/browse/#svn%2Ftrunk%2Finclude%2Fleveldb) through Java facade.

How to build
--------------------
Checkout the project and run in command line : 
* 'make' - checkout leveldb project from svn, compile it and build ready to use jar.

Build is only tested under Linux. 
Possible problems : 
* no internet connection to checkout leveldb from googlecode
* leveldb can not be built under certain environment (under Cygwin in Windows)
* JAVA_HOME variable is not defined
* swig is not installed

What is not supported
--------------------
There are some things still not supp

Contribution
--------------------
Please feel free to make for and provide your pull requests :)


Additional
--------------------



Example
-----------