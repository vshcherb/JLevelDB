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
  %clearnodefaultctor;

}


%inline %{
 namespace leveldb {
 
   class DBWriteBatch {
      public:
       WriteBatch wb;
       // Store the mapping "key->value" in the database.
       void Put(const std::string key, const std::string value) {
          wb.Put(Slice(key), Slice(value));
       }
       void Delete(std::string key) {
          wb.Delete(Slice(key));
       }
       void Clear() {
          wb.Clear();
       }
   };

  class DBAccessor {
    public :
     DB* pointer;
     Status Open(const Options& options,
                     const std::string& name) {
	    return DB::Open(options, name, &pointer);
     }
     
      char const* Get(const ReadOptions& options, const std::string key) {
          std::string val;
          Status st = pointer -> Get(options, Slice(key), &val);
          if(st.ok()) {
             return val.c_str();
          } else {
             return NULL;
          }          
      }
       
      Status Write(const WriteOptions& options, DBWriteBatch& updates) {
          return pointer -> Write(options, &updates.wb);
      } 
      
      Status Put(const WriteOptions& options, const std::string key, const std::string value) {
          return pointer -> Put(options, Slice(key), Slice(value));
      }
      
      Status Delete(const WriteOptions& options, const std::string key) {
          return pointer -> Delete(options, Slice(key));
      }
       
  };

 }
%}

