package com.anvisics.jleveldb;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import com.anvisics.jleveldb.ext.DBAccessor;
import com.anvisics.jleveldb.ext.DBWriteBatch;
import com.anvisics.jleveldb.ext.Options;
import com.anvisics.jleveldb.ext.ReadOptions;
import com.anvisics.jleveldb.ext.Status;
import com.anvisics.jleveldb.ext.WriteOptions;


public class LevelDBAccess {
	
	private static Boolean loaded = null;
	
	public static boolean load() {
        if (loaded != null) return loaded == Boolean.TRUE;

        String libpath = System.getProperty("com.anvisics.jleveldb.lib.path");
        String libname = System.getProperty("com.anvisics.jleveldb.lib.name");
        if (libname == null) libname = System.mapLibraryName("jleveldb");

        // look for a pre-installed library
        try {
            if (libpath == null) System.loadLibrary("jleveldb");
            else System.load(new File(libpath, libname).getAbsolutePath());

            loaded = Boolean.TRUE;
            return true;
        } catch (UnsatisfiedLinkError e) { } // fall through

        // guess what a bundled library would be called
        String osname = System.getProperty("os.name").toLowerCase();
        String osarch = System.getProperty("os.arch");
        if (osname.startsWith("mac os")) {
            osname = "mac";
            osarch = "universal";
        }
        if (osname.startsWith("windows"))
            osname = "win";
        if (osname.startsWith("sunos"))
            osname = "solaris";
        if (osarch.startsWith("i") && osarch.endsWith("86"))
            osarch = "x86";
        libname = "jleveldb-" + osname + '-' + osarch + ".lib";

        // try a bundled library
        try {
            ClassLoader cl = LevelDBAccess.class.getClassLoader();
            InputStream in = cl.getResourceAsStream(libname);
            if (in == null)
                throw new Exception("libname: "+libname+" not found");
            File tmplib = File.createTempFile("jleveldb-", ".lib");
            tmplib.deleteOnExit();
            OutputStream out = new FileOutputStream(tmplib);
            byte[] buf = new byte[1024];
            for (int len; (len = in.read(buf)) != -1;)
                out.write(buf, 0, len);
            in.close();
            out.close();

            System.load(tmplib.getAbsolutePath());

            loaded = Boolean.TRUE;
            return true;
        } catch (Exception e) { e.printStackTrace();}

        loaded = Boolean.FALSE;
        return false;
    }
	
	public static DBAccessor getDBAcessor(){
		if(!load()){
			throw new IllegalStateException("Native library not found.");
		}
		DBAccessor dbs = new DBAccessor();
		return dbs;
	}

}
