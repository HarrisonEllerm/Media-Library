//
//  MultiMediaCollection.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaCollection: NSMMCollection {
   
    //The collection of files
    var collection: [MMFile]

    //Multimap of metadata value to MMFile
    private var metadataValueToFileMultiMap: [String: [MMFile]]

    //Count of files within the collection
    private var count: Int

    init() {
        collection = [MMFile]()
        metadataValueToFileMultiMap = [String: [MMFile]]()
        count = 0
    }

    ///
    /// Adds a file to the multi-media collection. This function
    /// also traverses the files metadata, and places the corresponding
    /// metadata into the multi-map, to allow O(1) access when searching.
    ///
    /// - parameter : file, the file to be added.
    ///
    func add(file: MMFile) {
        collection.append(file)
        for meta in file.metadata {
            if let _ = self.metadataValueToFileMultiMap[meta.value] {
                metadataValueToFileMultiMap[meta.value]?.append(file)
            } else {
                metadataValueToFileMultiMap.updateValue([file], forKey: meta.value)
            }
        }
        count += 1
    }

    ///
    /// Returns the count of files within the collection.
    ///
    /// - returns: an Int representing the count of files
    ///            within the collection.
    ///
    func getCount() -> Int {
        return self.count
    }

    ///
    /// Adds metadata to a file, and then updates
    /// that file within the collection.
    ///
    /// - parameter : metadata, the metadata to be added.
    /// - parameter : file, the file that the metadata is to be added to.
    ///
    ///
    func add(metadata: MMMetadata, file: MMFile) {
        if let upCastFile = file as? MultiMediaFile {
            //If file was successfully modified
            if upCastFile.addMetadata(meta: metadata) {
                if let _ = self.metadataValueToFileMultiMap[metadata.value] {
                    metadataValueToFileMultiMap[metadata.value]?.append(file)
                } else {
                    metadataValueToFileMultiMap.updateValue([file], forKey: metadata.value)
                }
            }
        }
    }

    /**
        Removes metadata from the collection
        as a whole.
     
        Unused due to removeMetadataWithKey behaving in a more
        useful way for our specific implementation.
        Perhaps eventually the MMCollection protocol could be
        revised to not include this (in this implementation).
     
        Remove metada from all files. Inverted Index.
        
     
         - parameter : metadata, the metadata to be removed.
    */
    func remove(metadata: MMMetadata) {
        print("Not supported: ")
        print(" > see removeMetadataWithKey(key: String, file: MMFile) instead")
    }

    ///
    /// Removes metadata with an associated key value
    /// from a file. This is used in both the del and del-all
    /// commands. Returns true if successful and false if not.
    /// There are two situations in which this opperation may
    /// return false:
    ///
    ///   (i)  The key value didn't exist in the file
    ///   (ii) Deleting the key value would result in a
    ///        file of a specific type becoming invalid.
    ///
    /// - parameter : key, the key value of the metadata to be removed.
    /// - parameter : file, the file to remove the metadata from.
    /// - returns: a boolean representing if the opperation was successful
    ///            or not.
    ///
    func removeMetadataFromFile(meta: MMMetadata, file: MMFile) -> Bool {
        if let upCastFile = file as? MultiMediaFile {
            //If metadata was successfully deleted from file
            if upCastFile.deleteMetaData(meta) {
                if var existingFiles = metadataValueToFileMultiMap[meta.value] {
                    for index in (0..<existingFiles.count).reversed() {
                        if existingFiles[index].path == file.path {
                            existingFiles.remove(at: index)
                            metadataValueToFileMultiMap[meta.value] = existingFiles
                        }
                    }
                }
                return true
            }
        }
        //Could not delete metadata
        return false
    }
    
    func rewriteMetadataToFile(meta: MMMetadata, file: MMFile) -> Bool {
        return false
    }

    ///
    /// Searches for and returns files within the collection that
    /// contain a particular value. Used primarily for the list <term> ...
    /// command.
    ///
    /// - parameter : term, the key value being search for.
    /// - returns: an array of files that contain the term.
    ///
    func search(term: String) -> [MMFile] {
        //If term exists return files
        if let res = metadataValueToFileMultiMap[term] {
            return res
        }
        //Return nothing as term wasn't in map
        return [MMFile]()
    }

    ///
    /// Returns all of the files within the collection. If
    /// the collection is empty, an empty array will be
    /// returned.
    ///
    /// - returns: all files within the collection.
    ///
    func all() -> [MMFile] {
        return collection
    }

    ///
    /// Returns files within the collection that have a
    /// specific key value pair defined. This differs from
    /// search(term: String) which only searches for values.
    ///
    /// - parameters: item, the metadata being searched for
    /// - returns: an array of files that contain the metadata
    ///            being searched for.
    ///
    func search(item: MMMetadata) -> [MMFile] {
        var searchResults = [MMFile]()
        for file in collection {
            if let upCastFile = file as? MultiMediaFile {
                if upCastFile.containsMetadata(meta: item) {
                    searchResults.append(upCastFile)
                }
            }
        }
        return searchResults
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
}

