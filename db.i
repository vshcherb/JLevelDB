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
 

 /* %nodefaultctor; 
  class DB {
    public:
  };
  %clearnodefaultctor; */ 

}


%inline %{
 namespace leveldb {
 
   class DBWriteBatch {
      private :
     WriteBatch wb;
      public:
       // Store the mapping "key->value" in the database.
       void put(const std::string key, const std::string value) {
          wb.Put(Slice(key), Slice(value));
       }
       
       void delete(std::string key) {
          wb.Delete(Slice(key));
       }
       
       void clear() {
          wb.Clear();
       }
   };


  class DBAccessor {
    public :
     DB* pointer;
     Status open(const Options& options,
                     const std::string& name) {
	    return DB::Open(options, name, &pointer);
     }
     
      char const* get(const ReadOptions& options, const std::string key) {
          std::string val;
          Status st = pointer -> Get(options, Slice(key), &val);
          if(st.ok()) {
             return val.c_str();
          } else {
             return NULL;
          }          
      }
       
      Status write(const WriteOptions& options, WriteBatch* updates) {
          return pointer -> Write(options, updates);
      } 
      
      Status put(const WriteOptions& options, const std::string key, const std::string value) {
          // printf("- %s %s\n - ", key.c_str(), value.c_str());
          return pointer -> Put(options, Slice(key), Slice(value));
      }
      
      Status delete(const WriteOptions& options, const std::string key) {
          return pointer -> Delete(options, Slice(key));
      }
       
  };

 }
%}

