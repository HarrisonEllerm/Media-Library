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
    private var count = 0
    
    //Description of contents
    var description: String {
        get {
            return "MultiMediaCollection[ \(collection)]"
        }
    }

    init() {
        collection = [MMFile]()
        metadataValueToFileMultiMap = [String: [MMFile]]()
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
    /// Adds metadata to a file, and then updates
    /// that file within the collection.
    ///
    /// - parameter : metadata, the metadata to be added.
    /// - parameter : file, the file that the metadata is to be added to.
    ///
    func add(metadata: MMMetadata, file: MMFile) {
        if let downCastFile = file as? MultiMediaFile {
            //If file was successfully modified
            if downCastFile.addMetadata(meta: metadata) {
               addMetadataToMultiMap(metadata: metadata, file: file)
            }
        }
    }
    
    ///
    /// Adds metadata to a file, and then updates
    /// that file within the collection.
    ///
    /// - parameter : metadata, the metadata to be added.
    /// - parameter : file, the file that the metadata is to be added to.
    ///
    func addMetadataToMultiMap(metadata: MMMetadata, file: MMFile) {
        if let _ = self.metadataValueToFileMultiMap[metadata.value] {
            metadataValueToFileMultiMap[metadata.value]?.append(file)
        } else {
            metadataValueToFileMultiMap.updateValue([file], forKey: metadata.value)
        }
    }

    ///
    /// Removes metadata from the collection
    /// as a whole.
    ///
    /// - parameter : metadata, the metadata to be removed.
    ///
    func remove(metadata: MMMetadata) {
        for currentFile in collection {
            let _ = removeMetadataFromFile(meta: metadata, file: currentFile)
        }
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
    /// - parameter : meta, the metadata to be removed.
    /// - parameter : file, the file to remove the metadata from.
    /// - returns: a boolean representing if the opperation was successful
    ///            or not.
    ///
    func removeMetadataFromFile(meta: MMMetadata, file: MMFile) -> Bool {
        if let downCastFile = file as? MultiMediaFile {
            //If metadata was successfully deleted from file
            if downCastFile.deleteMetaData(meta) {
                //Handle the maps
                return removeMetadataFromMultiMap(meta: meta, file: file)
            }
        }
        //Could not delete metadata
        return false
    }
    
    ///
    /// Removes metadata from the multimap.
    ///
    /// - parameter : meta, the metadata to be removed.
    /// - parameter : file, the file to remove the metadata from.
    /// - returns: a boolean representing if the opperation was successful
    ///            or not.
    ///
    private func removeMetadataFromMultiMap(meta: MMMetadata, file: MMFile) -> Bool {
        if var existingFilesByValue = metadataValueToFileMultiMap[meta.value] {
            for index in (0..<existingFilesByValue.count).reversed() {
                if existingFilesByValue[index].path == file.path {
                    existingFilesByValue.remove(at: index)
                    metadataValueToFileMultiMap[meta.value] = existingFilesByValue
                }
                return true
            }
        }
        return false
    }
    
    ///
    /// Rewrites metadata to a file. I.e. the metadata being passed
    /// in contains the 'old' key and 'new' value. The 'old' value
    /// is then replaced by the 'new' value.
    ///
    /// - parameter : metadata, the instance containing the old key and
    ///               new value.
    /// - parameter : file, the file that is being opperated on.
    /// - returns: a boolean depecting if the opperation was succesful
    ///
    func rewriteMetadataToFile(meta: MMMetadata, file: MMFile) -> Bool {
        if let downCastFile = file as? MultiMediaFile {
            let oldMetaData = downCastFile.getMetaDataFromKey(key: meta.keyword)
            for metaD in oldMetaData {
                let _ = removeMetadataFromMultiMap(meta: metaD, file: file)
            }
            addMetadataToMultiMap(metadata: meta, file: file)
            return downCastFile.rewriteMetadata(meta: meta)
        }
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
    /// - parameters: item, the metadata being searched for.
    /// - returns: an array of files that contain the metadata
    ///            being searched for.
    ///
    func search(item: MMMetadata) -> [MMFile] {
        var searchResults = [MMFile]()
        for file in collection {
            if let downCastFile = file as? MultiMediaFile {
                if downCastFile.containsMetadata(meta: item) {
                    searchResults.append(downCastFile)
                }
            }
        }
        return searchResults
    }
}

extension MultiMediaCollection {
    
    ///
    /// A function used when testing to test if
    /// a file has or hasn't been added to the collection.
    ///
    /// - parameter : fileUrl, the path of the file being tested.
    /// - returns: a boolean representing if it is in the collection
    ///            or not.
    ///
    func containsFile(fileUrl: String) -> Bool {
        return self.collection.contains(where: { (mmfile) -> Bool in
            if mmfile.path == fileUrl {
                return true
            }
            return false
        })
    }

    ///
    /// A function used when testing to retrieve a file
    /// from the library via its path. Returns an MMFile
    /// optional.
    ///
    /// - parameter: fileUrl, the path of the file being retrieved.
    /// - returns: a MMFile? representing the file if it was found.
    func getFile(fileUrl: String) -> MMFile? {
        for item in self.collection {
            if item.path == fileUrl {
                return item
            }
        }
        return nil
    }
}

