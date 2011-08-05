package com.anvisics.jleveldb;

import java.io.File;

import com.anvisics.jleveldb.ext.DBAccessor;
import com.anvisics.jleveldb.ext.DBIterator;
import com.anvisics.jleveldb.ext.DBTable;
import com.anvisics.jleveldb.ext.DBTableBuilder;
import com.anvisics.jleveldb.ext.DBWriteBatch;
import com.anvisics.jleveldb.ext.Options;
import com.anvisics.jleveldb.ext.ReadOptions;
import com.anvisics.jleveldb.ext.Status;
import com.anvisics.jleveldb.ext.WriteOptions;

public class TestDBAccess {
	private static File f1 = new File("/home/victor/projects/JavaLevelDB/db");
	private static File f3 = new File("/home/victor/projects/JavaLevelDB/table2");
	private static File f2 = new File("/home/victor/projects/JavaLevelDB/table");
	public static void main(String[] args) {
		LevelDBAccess.load();
		
		testSimple();

		testBatchUpdateAndIterator();
		
		testTableBuilder();
		
	}
	
	private static void assertTrue(boolean cond, String message){
		if(!cond){
			throw new IllegalArgumentException(message);
		}
	}

	
	private static void testSimple() {
		DBAccessor dbAccessor = LevelDBAccess.getDBAcessor();
		f1.mkdirs();
		Options options = new Options();
		options.setCreateIfMissing(true);
		Status status = dbAccessor.open(options, f1.getAbsolutePath());
		
		System.out.println("Open file ok - " + status.ok());
		assertTrue(status.ok(), "File not opened");
		
		WriteOptions wo = new WriteOptions();
		ReadOptions ro = new ReadOptions();
		ro.setVerifyChecksums(true);
		ro.setFillCache(true);
		
		dbAccessor.put(wo, "1", "2");
		System.out.println("Put(1) : '2' - " + dbAccessor.getLastStatus().ok());
		String get = dbAccessor.get(ro, "1");
		System.out.println("Get(1) : '"+get+"' - " + dbAccessor.getLastStatus().ok());
		
		get = dbAccessor.get(ro, "2");
		System.out.println("Get(2) : '"+get+"' - " + dbAccessor.getLastStatus().ok());
		
		dbAccessor.remove(wo, "1");
		
		get = dbAccessor.get(ro, "1");
		System.out.println("After delete Get(1) : '"+get+"' - " + dbAccessor.getLastStatus().ok());
		
		dbAccessor.delete();
		System.out.println("-------\n");
	}
	
	private static void testBatchUpdateAndIterator() {
		DBAccessor dbAccessor = LevelDBAccess.getDBAcessor();
		f3.mkdirs();
		Options options = new Options();
		options.setCreateIfMissing(true);
		
		Status status = dbAccessor.open(options, f3.getAbsolutePath());
		System.out.println("Open file ok - " + status.ok());
		assertTrue(status.ok(), "File not opened");
		
		WriteOptions wo = new WriteOptions();
		ReadOptions ro = new ReadOptions();
		ro.setVerifyChecksums(true);
		ro.setFillCache(true);

		DBWriteBatch updates = new DBWriteBatch();

		System.out.println("Store from 5-1000 key^2 to db." );
		for (int i = 5; i < 1000; i++) {
			updates.Put(i + "", (i * i) + "");
		}
		dbAccessor.write(wo, updates);

		DBIterator iterator = dbAccessor.newIterator(ro);
		iterator.seekToFirst();
		// iterate over all entries
		int count = 0;
		while(iterator.valid()){
			iterator.next();
			count++;
		}
		System.out.println("Values in db : " + count);

		dbAccessor.delete();
		System.out.println("-------\n");
	}

	private static void testTableBuilder() {
		f2.getParentFile().mkdirs();
		
		Options opts = new Options();
		opts.setCreateIfMissing(true);
		
		DBTableBuilder builder = new DBTableBuilder(opts);
		Status status = builder.open(f2.getAbsolutePath());
		System.out.println(status.ToString());
		assertTrue(status.ok(), "File not opened");
		
		for(int i=0; i< 1000; i++){
			builder.add(""+i, ""+(i*i));
		}
		builder.flush();
		builder.finish();
		System.out.println("Finish creating table");
		
		
		
		DBTable dbt = DBTable.open(opts, f2.getAbsolutePath(), f2.length());
		DBIterator iterator = dbt.newIterator(new ReadOptions());
		iterator.seekToFirst();
		// iterate over all entries
		int count = 0;
		while(iterator.valid()){
			iterator.next();
			count++;
		}
		System.out.println("Values in db : " + count);
		
		dbt.delete();
		System.out.println("-------\n");
	}
}

