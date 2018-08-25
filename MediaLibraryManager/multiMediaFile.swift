//
//  MultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 2/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaFile: MMFile {

    var metadata: [MMMetadata]

    private var metadataKeyValueMultiMap: [String: [String]]

    var filename: String

    var path: String

    var type: MediaType

    var description: String {
        get {
            return "MultiMediaFile[Path: \(path), Filename: \(filename), MediaType: \(type), Metadata: \(metadata)]"
        }
    }

    init(metadata: [MMMetadata], filename: String, path: String, type: MediaType) {
        self.metadata = metadata
        self.metadataKeyValueMultiMap = [String: [String]]()
        self.filename = filename
        self.path = path
        self.type = type
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


    //Check if a file contains metadata
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


    //Adds metadata to a file
    func addMetadata(meta: MMMetadata) -> Bool {
        if !(containsMetadata(meta: meta)) {
            metadata.append(meta)
            //If the keyword already exists, add value to list
            if var existingValues = self.metadataKeyValueMultiMap[meta.keyword] {
                existingValues.append(meta.value)
                metadataKeyValueMultiMap[meta.keyword] = existingValues
            } else {
                //Insert the keyword, create value list
                metadataKeyValueMultiMap.updateValue([meta.value], forKey: meta.keyword)
            }
            return true
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
