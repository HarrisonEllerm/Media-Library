//
//  MultiMediaCollection.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaCollection: MMCollection, MMCollectionDeleter {
    
    //The collection of files
    var collection : [MMFile]
    //Count of files within the collection
    var count : Int
    
    init() {
        collection = [MMFile]()
        count = 0
    }
    
    /**
        Adds a file to the collection.
     
         - parameter : file, the file to be added.
    */
    func add(file: MMFile) {
        collection.append(file)
        count += 1
    }
    
    /**
        Adds metadata to a file, and then updates
        that file within the collection.
     
        - parameter : metadata, the metadata to be added.
        - parameter : file, the file that the metadata is to be added to.
     
    */
    func add(metadata: MMMetadata, file: MMFile) {
        if let upCastFile = file as? MultiMediaFile {
            upCastFile.metadata.append(metadata)
            self.replaceFile(file, upCastFile)
        }
    }
    
    /**
        Removes metadata from the collection
        as a whole.
     
        Unused due to removeMetadataWithKey behaving in a more
        useful way for our specific implementation.
        Perhaps eventually the MMCollection protocol could be
        revised to not include this (in our implementation).
     
         - parameter : metadata, the metadata to be removed.
    */
    func remove(metadata: MMMetadata) {
        print("Not supported: ")
        print(" > see removeMetadataWithKey(key: String, file: MMFile) instead")
    }
    
    /**
        Removes metadata with an associated key value
        from a file. This is used in both the del and del-all
        commands. Returns true if successful and false if not.
        There are two situations in which this opperation may
        return false:
     
            (i) The key value didn't exist in the file
            (ii) Deleting the key value would result in a
                 file of a specific type becoming invalid.
    
        - parameter : key, the key value of the metadata to be removed.
        - parameter : file, the file to remove the metadata from.
        - returns: a boolean representing if the opperation was successful
                   or not.
    */
    func removeMetadataWithKey(key: String, file: MMFile) -> Bool {
        if let upCastFile = file as? MultiMediaFile {
            let success = upCastFile.deleteMetaData(key)
            if success {
                self.replaceFile(file, upCastFile)
                //Metadata successfully deleted
                return true
            }
        }
        //Could not delete metadata
        return false
    }
    
    /**
        Searches for and returns files within the collection that
        contain a particular key. Used primarily for the list <term> ...
        command.
  
        - parameter : term, the key value being search for.
        - returns: an array of files that contain the term.
     
     */
    func search(term: String) -> [MMFile] {
        var returnList = [MultiMediaFile]()
        for file in self.collection {
            if let upCastFile = file as? MultiMediaFile {
                if upCastFile.containsKey(term: term) {
                    returnList.append(upCastFile)
                }
            }
        }
        return returnList
    }
    
    /**
        Returns all of the files within the collection.
     
        - returns: all files within the collection term.
     */
    func all() -> [MMFile] {
        return collection
    }
    
    func search(item: MMMetadata) -> [MMFile] {
        return [MMFile]()
    }
    
    var description: String {
        get {
            return ""
        }
    }

}

extension MultiMediaCollection {
    
    func containsFile(fileUrl: String) -> Bool {
        return self.collection.contains(where: { (mmfile) -> Bool in
            if mmfile.path == fileUrl {
                return true
            }
            return false
        })
    }
    
    func getFile(fileUrl: String) -> MMFile? {
        for item in self.collection {
            if item.path == fileUrl {
                return item
            }
        }
        return nil
    }
    
    func replaceFile(_ file: MMFile, _ upCastFile: MultiMediaFile) {
        for var item in self.collection {
            if item.path == file.path {
                item = upCastFile
            }
        }
    }
}

