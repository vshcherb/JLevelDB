package com.anvisics.jleveldb;

import com.anvisics.jleveldb.ext.DBAccessor;
import com.anvisics.jleveldb.ext.DBIterator;
import com.anvisics.jleveldb.ext.DBWriteBatch;
import com.anvisics.jleveldb.ext.Options;
import com.anvisics.jleveldb.ext.ReadOptions;
import com.anvisics.jleveldb.ext.Status;
import com.anvisics.jleveldb.ext.WriteOptions;

public class TestDBAccess {
	public static void main(String[] args) {
		DBAccessor dbAccessor = LevelDBAccess.getDBAcessor();
		Options options = new Options();
		options.setCreateIfMissing(true);
		Status status = dbAccessor.open(options, "tmp/JavaLevelDB/db");

		if (!status.ok()) {
			System.out.println(status.ToString());
			throw new UnsupportedOperationException();
		}
		WriteOptions opts = new WriteOptions();
		ReadOptions ro = new ReadOptions();

		long ms = System.currentTimeMillis();

		DBWriteBatch updates = new DBWriteBatch();

		for (int i = 5; i < 1000; i++) {
			updates.Put(i+"", (i * i) + "");
		}
		dbAccessor.write(opts, updates);
		updates.delete();
		ro.setVerifyChecksums(true);
		for (int i = 0; i < 10; i++) {
			String value = dbAccessor.get(ro, i + "");
			System.out.println(value);
		}

		DBIterator it = dbAccessor.newIterator(ro);
		it.seekToFirst();
		
		for (int i = 0; i < 10; i++) {
			System.out.println(it.key() + "\t\t\t" + it.value());
			it.next();
		}

		it.delete();
		System.out.println((System.currentTimeMillis() - ms) + " ms");
	}
}

