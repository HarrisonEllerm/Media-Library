//
//  MultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 2/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaFile: MMFile {
    //The files metadata
    var metadata: [MMMetadata]
    //The files metadata key to metadata value multi-map
    private var metadataKeyValueMultiMap = [String: [String]]()
    //The files name
    var filename: String
    //The path to the file
    var path: String
    //The MediaType associated with the file
    var type: MediaType

    var description: String {
        get {
            return "MultiMediaFile[Path: \(path), Filename: \(filename), MediaType: \(type), Metadata: \(metadata)]"
        }
    }

    init(metadata: [MMMetadata], filename: String, path: String, type: MediaType) {
        self.metadata = metadata
        self.filename = filename
        self.path = path
        self.type = type
        for item in metadata {
            updateMap(meta: item)
        }
    }

    ///
    /// Updates the internal map for a particular metadata
    /// instance. Called initially upon instantiation, and then
    /// again if more metadata is added to the file.
    ///
    /// - parameter : meta, the metadata instance.
    ///
    private func updateMap(meta: MMMetadata) {
        if let _ = self.metadataKeyValueMultiMap[meta.keyword] {
            metadataKeyValueMultiMap[meta.keyword]?.append(meta.value)
        } else {
            //Insert the keyword, create value list
            metadataKeyValueMultiMap.updateValue([meta.value], forKey: meta.keyword)
        }
    }

    ///
    /// Get all metadata within a file that has the key
    /// specified. Queries the map to find this information
    /// and builds out MMetadata array to return.
    ///
    /// - parameter : key, the key value of the medata
    /// - returns: an array of metata that has the key specified
    ///
    func getMetaDataFromKey(key: String) -> [MMMetadata] {
        var meta = [MultiMediaMetaData]()
        if let res = metadataKeyValueMultiMap[key] {
            for value in res {
                let metadata = MultiMediaMetaData(keyword: key, value: value)
                meta.append(metadata)
            }
        }
        return meta
    }


    /// This function checks if a particular file
    /// contains metadata. It essentially queries the map
    /// initially via the key (O(1)) then proceeds to query
    /// the result if it finds an array of values (O(n) where
    /// n is the number of values associated with the key).
    ///
    /// - parameter : meta, the metadata to search for.
    /// - returns: a boolean representing if the metadata
    ///            was found or not.
    ///
    func containsMetadata(meta: MMMetadata) -> Bool {
        //Found keyword
        if let res = metadataKeyValueMultiMap[meta.keyword] {
            //Found value
            if res.contains(meta.value) {
                return true
            }
        }
        return false
    }

    /// This function checks if a particular file
    /// contains a key associated with a instance of
    /// metadata. It essentially queries the map
    /// providing a constant time check to see if the key
    /// exists within the files metadata.
    ///
    /// - parameter : meta, the metadata containing the key
    ///               to search for.
    /// - returns: a boolean representing if the metadata
    ///            was found or not.
    ///
    private func containsKey(meta: MMMetadata) -> Bool {
        //Found keyword
        if let _ = metadataKeyValueMultiMap[meta.keyword] {
            return true
        }
        return false
    }

    /// Adds metadata to a file. If the file is
    /// successfully modified, the internal multi-map
    /// is also updated.
    ///
    /// - parameter : meta, the metadata to add
    /// - returns: a boolean representing if it was
    ///            successfully added or not.
    ///
    func addMetadata(meta: MMMetadata) -> Bool {
        if !(containsMetadata(meta: meta)) {
            metadata.append(meta)
            //If the keyword already exists, add value to list
            self.updateMap(meta: meta)
            return true
        }
        return false
    }
    
    /// Rewrites metadata to a file. If the file is
    /// successfully modified, the internal multi-map
    /// is also updated.
    ///
    /// - parameter : meta, the metadata to rewrite
    /// - returns: a boolean representing if it was
    ///            successfully rewritten or not.
    ///
    func rewriteMetadata(meta: MMMetadata) -> Bool {
        if !(containsKey(meta: meta)) {
            return false
            //It does contain the key value
        } else {
            if let preValues = metadataKeyValueMultiMap[meta.keyword] {
                for value in preValues {
                    let metaToDelete = MultiMediaMetaData(keyword: meta.keyword, value: value)
                    //Since we have already tested that the key exists,
                    //there is no need to check the return of self.delete
                    let _ = self.delete(metaToDelete)
                }
                return self.addMetadata(meta: meta)
            }
        }
        return false
    }

    ///
    /// This function is really a sanity check to ensure
    /// that when a user attempts to delete a particular
    /// key, the key they are trying to delete, if removed,
    /// would not make the file invalid. 
    ///
    /// - parameter : key, the key of the metadata to delete
    ///               if valid.
    /// - returns: a boolean representing if the metadata
    ///             was successfully deleted or not.
    ///
    func deleteMetaData(_ meta: MMMetadata) -> Bool {
        switch self.type {
        case MediaType.image:
            if meta.keyword != "creator" &&
                meta.keyword != "resolution" {
                return delete(meta)
            } else {
                return false
            }
        case MediaType.audio:
            if meta.keyword != "creator" &&
                meta.keyword != "runtime" {
                return delete(meta)
            } else {
                return false
            }
        case MediaType.document:
            if meta.keyword != "creator" {
                return delete(meta)
            } else {
                return false
            }
        case MediaType.video:
            if meta.keyword != "creator" &&
                meta.keyword != "resolution" &&
                meta.keyword != "runtime" {
                return delete(meta)
            } else {
                return false
            }
        }
    }

    ///
    /// Deletes a metadata instance associated with
    /// a particular key value from the file.
    ///
    /// - parameter : meta, the metadata item to delete.
    /// - returns: a boolean representing if the metadata
    ///             was successfully deleted or not.
    ///
    private func delete(_ meta: MMMetadata) -> Bool {
        //If it actually exists within the file
        if var existingValues = metadataKeyValueMultiMap[meta.keyword] {
            //Remove from multimap
            if existingValues.count == 1 {
                metadataKeyValueMultiMap.removeValue(forKey: meta.keyword)
            } else {
                for index in (0..<existingValues.count).reversed() {
                    if existingValues[index] == meta.value {
                        existingValues.remove(at: index)
                        metadataKeyValueMultiMap[meta.keyword] = existingValues
                    }
                }
            }
            //Remove from metadata array
            for index in (0..<metadata.count).reversed() {
                if metadata[index].keyword == meta.keyword {
                    metadata.remove(at: index)
                }
            }
            return true
        }
        return false
    }
}
