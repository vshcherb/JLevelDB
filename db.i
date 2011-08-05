%module Leveldb

%include std_string.i
%{
#include "leveldb/write_batch.h"
#include "leveldb/db.h"
#include "leveldb/options.h"
%}

namespace leveldb {

  struct WriteOptions {
    WriteOptions();
   
    // Default: false
    bool sync;
   
    // Default: NULL
    //const Snapshot** post_write_snapshot;
   };
   

  class Status {
    public :
    // Returns true iff the status indicates success.
    bool ok();

    // Returns true iff the status indicates a NotFound error.
    bool IsNotFound();

    std::string ToString();
  };

  enum CompressionType {
    // NOTE: do not change the values of existing entries, as these are
    // part of the persistent format on disk.
    kNoCompression     = 0x0,
    kSnappyCompression = 0x1
  };


  struct Options {
    Options();

    bool create_if_missing;

    // Default: false
    bool error_if_exists;

    // Default: false
    bool paranoid_checks;
  
    // Default: 4MB
    size_t write_buffer_size;

    // Default: 1000
    int max_open_files;

    // Cache* block_cache;

    // Default: 4K
    size_t block_size;
    
    // Default: 16
    int block_restart_interval;
  
    CompressionType compression;
  };
  
  
  struct ReadOptions {
	bool verify_checksums;
    bool fill_cache;

    // Default: NULL
    //const Snapshot* snapshot;
  };
  
  %nodefaultctor;
  class WriteBatch {
  };
  
  class DB {
  };
  class Iterator {
  };
  %clearnodefaultctor;
  
  // Destroy the contents of the specified database.
  // Be very careful using this method.
  Status DestroyDB(const std::string& name, const Options& options);

  Status RepairDB(const std::string& dbname, const Options& options);

}

%inline %{
 namespace leveldb {
 
 
   class DBWriteBatch {
      public:
       WriteBatch wb;
       // Store the mapping "key->value" in the database.
       void Put(const char* key, const char* value) {
          wb.Put(Slice(key), Slice(value));
       }
       void Delete(const char* key) {
          wb.Delete(Slice(key));
       }
       void Clear() {
          wb.Clear();
       }
   };
   
   class DBIterator {
       friend class DBAccessor;
       Iterator* it;
       DBIterator(Iterator* i) {
         it = i;
       }
       public :
       ~DBIterator() { delete it; } 
         // An iterator is either positioned at a key/value pair, or not valid.  
         bool Valid() { return it->Valid(); }
         
         void SeekToFirst() { return it->SeekToFirst(); }
         
         void SeekToLast() { return it->SeekToLast(); }
         
         void Seek(const std::string& str) { return it->Seek(Slice(str)); }
  
         // REQUIRES: Valid()       
         void Next() { return it-> Next(); }
         
         // REQUIRES: Valid()
         // After this call, Valid() istrue iff the iterator was not positioned at the first entry in source.
         void Prev() { return it-> Prev(); }
         
         // REQUIRES: Valid()
         std::string key() { return it->key().ToString(); }
         
         // REQUIRES: !AtEnd() && !AtStart()
         std::string value() {
                // be very strict because ToString can be destroyed
                // std::string str(it->value().data(), it->value().size());
         		// return str;
         		return it->value().ToString();
          }
         
         // If an error has occurred, return it.  Else return an ok status.
         Status status() { return it->status(); }
   };



   class DBAccessor {
     public :
     DB* pointer;
     Status lastStatus;
     Status Open(const Options& options,
                     const std::string& name) {
	    return DB::Open(options, name, &pointer);
     }
     
     std::string Get(const ReadOptions& options, char const* key) {
          std::string val;
          lastStatus = pointer -> Get(options, Slice(key), &val);
          return val;
      }
       
      Status Write(const WriteOptions& options, DBWriteBatch& updates) {
          lastStatus=pointer -> Write(options, &updates.wb);
          return lastStatus;
      } 
      
      Status Put(const WriteOptions& options, const std::string key, const std::string value) {
          lastStatus=pointer -> Put(options, Slice(key), Slice(value));
          return lastStatus;
      }
      
      Status Delete(const WriteOptions& options, const std::string key) {
           lastStatus=pointer -> Delete(options, Slice(key));
           return lastStatus;
      }
       
      // Return a heap-allocated iterator over the contents of the database.
  	  // Caller should delete the iterator when it is no longer needed.
      DBIterator* NewIterator(const ReadOptions& options) {
         return new DBIterator(pointer -> NewIterator(options));
      };
  };

 }
%}

