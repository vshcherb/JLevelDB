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
		options.setCreate_if_missing(true);
		Status status = dbAccessor.Open(options, "/home/victor/projects/OsmAnd/navigation_ws/JavaLevelDB/db");

		if (!status.ok()) {
			System.out.println(status.ToString());
			throw new UnsupportedOperationException();
		}
		WriteOptions opts = new WriteOptions();
		ReadOptions ro = new ReadOptions();

		long ms = System.currentTimeMillis();

		DBWriteBatch updates = new DBWriteBatch();

		for (int i = 5; i < 1000; i++) {
			// dbAccessor.Put(opts, i + "", (i * i) + "фыва");
			updates.Put(i + "", (i * i) + "фыва");
		}

		dbAccessor.Write(opts, updates);
		updates.delete();

		for (int i = 0; i < 10; i++) {
			String value = dbAccessor.Get(ro, i + "");
			System.out.println(value);
		}

		DBIterator it = dbAccessor.NewIterator(ro);
		it.SeekToFirst();
		int i = 0;
		while (it.Valid() && i < 50) {
			System.out.println(it.key() + " " + it.value());
			i++;
			it.Next();
		}

		it.delete();
		System.out.println((System.currentTimeMillis() - ms) + " ms");
	}
}

