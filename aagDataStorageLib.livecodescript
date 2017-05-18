script "aagDataStorageLib"
# ## AAG DATA STORAGE LIB
#
# Version __0.3 BETA__
# by Andre Alves Garzia ({mailto:support@andregarzia.com})
#
# The Data Storage Library is an add-on for the DB Lib and can't be used without it.
#
# ### Objective
# A quick and easy generic data storage library that requires no SQL knowledge.
#
#
# DB LIB URL: {http://www.andregarzia.com/page/dblib}
# Online API Reference for Data Storage Lib: {http://www.andregarzia.com/aux/datastorageapi}
# Guide for DB Lib: {http://www.andregarzia.com/aux/dblibguide}
# Support Forum: {http://andregarzia.com/forum}. This is the main venue for getting your questions answered and providing feedback.
#
# ### Version Changes
#
# v0.3 BETA: Fixed a bug in dsGet() where it would fail to return the key.
#

local dsA


--> Private Auxiliary Functions
private function _dsHexDigest pvalue
   local tRes
   put md5Digest(pValue) into tMD5
   get binaryDecode("H*",tMD5,tRes)
   return tRes
end _dsHexDigest 


private command _dsAddKeyIfNeeded pStorageName, @pDataA
   if pDataA["key"] is empty then
      put "item_" & the ticks & "_" & random(9999) into pDataA["key"]
      put dsKeyExists(pStorageName, pDataA["key"]) into tFlag
      repeat while tFlag is true
         put "item_" & the ticks & "_" & random(9999) into pDataA["key"]
         put dsKeyExists(pStorageName, pDataA["key"]) into tFlag
      end repeat
   end if
end _dsAddKeyIfNeeded

private function _dsFolderForDatabaseFile pStorageName, pAppBundleID
   
   switch the platform
      case "macos"
         put "~" & specialfolderpath("asup") & "/" & pAppBundleID & "/" & pStorageName & ".sqlite" into tStoragePath
         break
      case "win32"
         put specialfolderpath("0x001a") & "\" & pAppBundleID & "\" & pStorageName & ".sqlite" into tStoragePath
         break
      case "linux"
         put "~/." & pAppBundleID & "/" & pStorageName & ".sqlite" into tStoragePath
         break
      case "iphone"
         put the documents folder & "/" & pStorageName & ".sqlite" into tStoragePath
         break
      case "android"
         put the documents folder & "/" & pStorageName & ".sqlite" into tStoragePath
         break
   end switch
   
   switch the platform
      case "win32"
         put "\" into tFolderSeparator
         break
      default 
         put "/" into tFolderSeparator
   end switch
   
   if the environment is not "mobile" then
      set the itemdel to tFolderSeparator
      put item 1 to -2 of tStoragePath into tStorageFolder
      if there is not a folder tStorageFolder then
         create folder tStorageFolder
         if the result is not empty then
            return "dserr, can't create support folder:" && the result
         end if
      end if
   end if
   
   return tStoragePath
end _dsFolderForDatabaseFile

private command _dsInitializeStorageFile pStoragePath
   put the cSQLiteTemplate of stack "aagDataStorageLib" into url ("binfile:" & pStoragePath)
   if the result is not empty then
      return "dserr, cannot initialize storage file:" && the result & cr & pStoragePath
   end if
end _dsInitializeStorageFile

--> Public API 

# This command opens a new storage for use. If the storage file does not exists, then a new file
# is created. You need to pass you application bundle id, it is usually something like:
#
#  com.andregarzia.myApp
#
# This bundle id is used to create the folder where the storage files are written. For example,
# if your bundle id is __com.andregarzia.contacts__ then the folder location on a Mac OS X machine will be:
#
# ~/Library/Application Support/com.andregarzia.contacts/
#
# The bundle id is not used when dealing with mobile software. On mobile platforms, the storage file is saved
# to the documents folder.
#
# dsOpen receives a storage name and the application bundle id.
#
# The storage name is used on the other commands and functions.
#
# If there is an error then dsOpen returns a string beginning with "dserr" in the result.
#
command dsOpen pStorageName, pAppBundleID
   
   put _dsFolderForDatabaseFile(pStorageName, pAppBundleID) into tStoragePath
   if "dserr" is in tStoragePath then
      return tStoragePath
   end if
   
   # Initialize storage file if needed.
   if there is not a file tStoragePath then
      _dsInitializeStorageFile tStoragePath
      if the result is not empty then
         return "dserr," & the result
      end if
   end if
   
   # Open database connection and store the ids.
   switch the platform
      case "win32"
         put "\" into tFolderSeparator
         break
      default 
         put "/" into tFolderSeparator
   end switch
   
   put the defaultfolder into tDF
   set the itemdel to tFolderSeparator
   put item 1 to -2 of tStoragePath into tStorageFolder
   put item -1 of tStoragePath into tFileName
   set the defaultfolder to tStorageFolder
   get revOpenDatabase("sqlite", tFileName,,,)
   set the defaultfolder to tDF
   
   if it is a number then
      put it into dsA[pStorageName]["id"]
      return empty
   else
      return "dserr, error opening storage file:" && it & cr & tStoragePath
   end if 
end dsOpen

# This commands saves an item into the given storage.
#
# You can save an array regardless of the array structure. Each item is saved with a key for reference.
# If you don't provide a _key_ element on the given array then a key will be generated for you. 
#
# After saving, dsSave will return the key of the saved item.
#
# *Parameters:* The storage name, this storage needs to be open with _dsOpen_.
# *Parameters:* An array to save.
#
# *Returns:* The key of the saved item.
#
# If an error happens dsSave will return an error beginning with dsErr or dbErr depending if
# the error happened on Data Storage Lib level or DB Lib level.
#
command dsSave pStorageName, pDataA
   put dbPreserveQueryParameters() into tCurrentQueryDataA  # Save possible query parameter data
   dbResetQuery    # Reset the query state
   _dsAddKeyIfNeeded pStorageName, pDataA    # Add key if needed. Items always need keys.
   
   # Check if the record exists in the database. If it does then we update the data. If it doesn't
   # we insert a new record
   if dsKeyExists(pStorageName, pDataA["key"]) is true then
      dbWhere "key", pDataA["key"]
      put pDataA["key"] into pRawDataA["key"]
      delete variable pDataA["key"]
      put the base64encode of the arrayencode of pDataA into pRawDataA["value"]
      put 1 into pRawDataA["version"]
      put _dsHexDigest(pRawDataA["value"]) into pRawDataA["md5"]
      get dbUpdate("item", pRawDataA, dsA[pStorageName]["id"])
   else
      put pDataA["key"] into pRawDataA["key"]
      delete variable pDataA["key"]
      put the base64encode of the arrayencode of pDataA into pRawDataA["value"]
      put 1 into pRawDataA["version"]
      put _dsHexDigest(pRawDataA["value"]) into pRawDataA["md5"]
      get dbInsert("item", pRawDataA, dsA[pStorageName]["id"])
   end if
   dbRestoreQueryParameters  tCurrentQueryDataA # Restore the old query parameter data
   if it is 1 then
      return pRawDataA["key"]
   else
      return it
   end if
end dsSave

# This command can save more than one record at once. To use it you pass the storage name and
# a multilevel array. This array on the first level has numeric keys going from 1 to the number of
# records you want to save. And on the second level is has the records you want to save. For example:
#
# put "blue" into tA[1]["color"]
# put "andre" into tA[1]["first_name"]
# put "garzia" into tA[1]["last_name"]
#
#
# put "red" into tA[2]["color"]
# put "jobs" into tA[2]["first_name"]
# put "steve" into tA[2]["last_name"]
#
#
# put "pizza" into tA[3]["food"]
# put "tea" into tA[3]["beverage"]
# put "cookies" into tA[3]["desert"]
#
# dsBatchSave "myStorage", tA
#
# Take notice that the item on tA[3] does not match the same elements of tA[1] and tA[2] and this doesn't
# matter. Data Storage Lib does not care about what you store as long as it is an array. In this example
# we don't provide the keys, so they are automatically generated.
#
# If there is an error during the batch processing, the loop will be aborted and an error will be returned
# beginning with "dserr".
#
command dsBatchSave pStorageName, pBatchDataA
   put the keys of pBatchDataA into tKeys
   sort numeric ascending tKeys
   repeat for each line x in tKeys
      dsSave pStorageName, pBatchDataA[x]
      if "dserr" is in the result then
         return "dserr, error inserting record" && x &"." && the result
      end if
   end repeat
end dsBatchSave

# This function receives the storage name and the key you are looking for.
# The array will be returned if the key is found or an error beginning with
# dsErr or dbErr depending if the error happened at Data Storage Level or DB Lib level.
#
function dsGet pStorageName, pKey
   put dbPreserveQueryParameters() into tCurrentQueryDataA  # Save possible query parameter data
   dbResetQuery    # Reset the query state
   
   if dsKeyExists(pStorageName, pKey) is true then
      dbWhere "key", pKey
      put dbGet("item", dsA[pStorageName]["id"]) into tRawRecordA
      dbRestoreQueryParameters  tCurrentQueryDataA
      put the arraydecode of the base64decode of tRawRecordA[1]["value"] into tRetValA
      put tRawRecordA[1]["key"] into tRetValA["key"]
      return tRetValA
   else
      dbRestoreQueryParameters  tCurrentQueryDataA
      return empty
   end if
end dsGet

# This function returns a multilevel array with all the items in a given storage.
# This is very good for map/reduce algorithms.
function dsGetAll pStorageName
   put dbPreserveQueryParameters() into tCurrentQueryDataA 
   dbResetQuery  
   put dbGet("item", dsA[pStorageName]["id"]) into tRawRecordsA
   repeat for each key x in tRawRecordsA
      put the arraydecode of the base64decode of tRawRecordsA[x]["value"] into tRetValA[x]
      put tRawRecordsA[x]["key"] into tRetValA[x]["key"]
   end repeat   
   dbRestoreQueryParameters  tCurrentQueryDataA
   return tRetValA
end dsGetAll

# This function returns a return-delimited list of all the keys in the storage.
function dsKeys pStorageName
   put dbPreserveQueryParameters() into tCurrentQueryDataA 
   dbResetQuery  
   dbColumns "key"
   put dbGet("item", dsA[pStorageName]["id"]) into tRetValA
   dbRestoreQueryParameters  tCurrentQueryDataA
   repeat for each key x in tRetValA
      put tRetValA[x]["key"] & cr after tKeys
   end repeat
   delete char -1 of tKeys
   return tKeys
end dsKeys

# This function returns true or false depending if the key is present on the storage
function dsKeyExists pStorageName, pKey
   put dbPreserveQueryParameters() into tCurrentQueryDataA 
   dbResetQuery  
   dbColumns "key"
   dbWhere "key", pKey
   put dbGet("item", dsA[pStorageName]["id"]) into tRetValA
   dbRestoreQueryParameters  tCurrentQueryDataA
   if the keys of tRetValA is empty then
      return false
   else
      return true
   end if
end dsKeyExists

# This command removes an item with the given key from the storage. If the key does not exists
# dsRemove will return a string in _the result_ beginning with _dsErr_.
command dsRemove pStorageName, pKey
   put dbPreserveQueryParameters() into tCurrentQueryDataA 
   dbResetQuery 
   if dsKeyExists(pStorageName, pKey) is true then
      dbWhere "key", pKey
      get dbDelete("item", dsA[pStorageName]["id"])
      dbRestoreQueryParameters  tCurrentQueryDataA
      return it
   else
      dbRestoreQueryParameters  tCurrentQueryDataA
      return "dserr, no such key"
   end if
end dsRemove

# This command removes all items from a given storage.
# It should return the number of items removed but for some weird
# reason RevDB is returning 0 regardless of the SQL command. So 0 is good.
command dsNuke pStorageName
   put dbPreserveQueryParameters() into tCurrentQueryDataA 
   dbResetQuery
   revExecuteSQL dsA[pStorageName]["id"], "DELETE FROM item"
   put the result into tR
   dbRestoreQueryParameters  tCurrentQueryDataA
   return tR
end dsNuke
