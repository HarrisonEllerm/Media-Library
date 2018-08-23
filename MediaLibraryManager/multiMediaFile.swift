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

    var metadataMultiMap: [String: [String]]

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
        self.metadataMultiMap = [String: [String]]()
        self.filename = filename
        self.path = path
        self.type = type
    }

    //Check if a file contains metadata
    func containsMetadata(meta: MMMetadata) -> Bool {
        //Found keyword
        if let res = metadataMultiMap[meta.keyword] {
            //Found value
            if res.contains(meta.value) {
                return true
            }
        }
        return false
    }


    //Adds metadata to a file
    func addMetadata(meta: MMMetadata) {
        if !(containsMetadata(meta: meta)) {
            metadata.append(meta)
            //If the keyword already exists, add value to list
            if var res = metadataMultiMap[meta.keyword] {
                res.append(meta.value)
            } else {
                //Insert the keyword, create value list
                metadataMultiMap.updateValue([meta.value], forKey: meta.keyword)
            }
        }
    }

    /**
        A function used when searching for files within the
        library that have a specified term (i.e. key) present.
     
        - parameter : term, the term that is being searched for
        - returns: a boolean representing if it was found or not.
    */
    func containsKey(term: String) -> Bool {
        if let _ = metadataMultiMap[term] {
            return true
        }
        return false
    }

    /**
        This function is really a sanity check to ensure
        that when a user attempts to delete a particular
        key, the key they are trying to delete, if removed,
        would not make the file invalid.
     
        - parameter : key, the key of the metadata to delete
                      if valid.
        - returns : a boolean representing if the metadata
                    was successfully deleted or not.
    */
    func deleteMetaData(_ key: String) -> Bool {
        switch self.type {
        case MediaType.image:
            if key != "creator" && key != "resolution" {
                return deleteWithKey(key)
            } else {
                return false
            }
        case MediaType.audio:
            if key != "creator" && key != "runtime" {
                return deleteWithKey(key)
            } else {
                return false
            }
        case MediaType.document:
            if key != "creator" {
                return deleteWithKey(key)
            } else {
                return false
            }
        case MediaType.video:
            if key != "creator" && key != "resolution" && key != "runtime" {
                return deleteWithKey(key)
            } else {
                return false
            }
        }
    }

    /**
        Deletes a metadata instance associated with
        a particular key value from the file.
     
        - parameter : key, the key of the metadata item
                      to delete.
        - returns : a boolean representing if the metadata
                    was successfully deleted or not.
     */
    private func deleteWithKey(_ key: String) -> Bool {
        //If it actually exists within the file
        if let _ = metadataMultiMap[key] {
            //Remove from multimap
            metadataMultiMap.removeValue(forKey: key)
            //Remove from metadata array
            for index in (0..<metadata.count).reversed() {
                if metadata[index].keyword == key {
                    metadata.remove(at: index)
                }
            }
            return true;
        }
        return false
    }
}
