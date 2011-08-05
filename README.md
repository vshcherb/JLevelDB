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

	// Loads library to corresponding OS if it is not loaded exception is thrown
	// Before library is loaded you can not create any object!
	// Library can be loaded in class initializator :  `static { boolean loaded = LevelDBAccess.load(); }`
	DBAccessor dbAccessor = LevelDBAccess.getDBAcessor();
	
	Options options = new Options();
	options.setCreateIfMissing(true);
	Status status = dbAccessor.open(options, "filepath");
	
	if (status.ok()) {
		WriteOptions opts = new WriteOptions();
		ReadOptions ro = new ReadOptions();
		dbAccessor.put(opts, "key", "value");
		assert "value".equals(dbAccessor.get(ro, "key"));
	}
	

What is to be verified and implemented
--------------------
There are some operations not linked with C++ [API](http://code.google.com/p/leveldb/source/browse/#svn%2Ftrunk%2Finclude%2Fleveldb) : 

* [Comparator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/comparator.h) - important enough (callback)
* [TableBuilder](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/table_builder.h) and [Table](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/table.h) - should be properly tested. There is no default API to read Table from middle of file but it can be implemented. 


Is it really needed ?

* [Cache](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/cache.h) - own implementation of cache 
* [Environment](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/env.h) - own implementation of RandomAccessFile, SequentialFile,...
* [Cleanup Function of Iterator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/iterator.h) 
* [WriteBatch Iterator](http://code.google.com/p/leveldb/source/browse/trunk/include/leveldb/write_batch.h) - iterate over entities to be writen


Contribution
--------------------
Please feel free to make forks and provide your pull requests :)


Additional
--------------------

That project provides very fast ArraySerializer that allows to store array of strings into string. The stream parser processes String in place and not allocate new memory.
With that helper you can serialize/deserialize every data structure like as array of arrays or map (as doubled array).
The format of serialization is pretty simple : `[Value, Value2, [ Value3 ]]`. It also supports quotation of important for deserialization characters. 

	int next;
	EntityValueTokenizer tokenizer = new EntityValueTokenizer();
	tokenizer.tokenize(value);

	while ((next = tokenizer.next()) != END) {
		if (next == ELEMENT) {
			// TODO process element 
			String value = tokenizer.value();
		} else if (next == START_ARRAY) {
			// TODO process start of inner array
		} else if (next == END_ARRAY) {
			// TODO process end of array
		}
	}

