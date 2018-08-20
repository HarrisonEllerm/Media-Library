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
        self.filename = filename
        self.path = path
        self.type = type
    }
    
    /**
        A function used when searching for files within the
        library that have a specified term (i.e. key) present.
     
        - parameter : term, the term that is being searched for
        - returns: a boolean representing if it was found or not.
    */
    func containsKey(term: String) -> Bool {
        for meta in self.metadata {
            if meta.keyword == term {
                return true
            }
        }
        return false
    }

    /**
        A function used primarily when testing to ensure
        that returns a boolean representing if the file
        contains a metadata key value pair or not.
     
        - parameter : meta, the metadata that is being searched for
        - returns: a boolean representing if it was found or not.
    */
    func containsMetaData(meta: MultiMediaMetaData) -> Bool {
        //Safe downcast
        let downcastedMetaData = meta as MMMetadata
        for item in metadata {
            if item.keyword == downcastedMetaData.keyword &&
                item.value == downcastedMetaData.value {
                return true
            }
        }
        return false
    }
    
    /**
     Deletes stuff
    */
    func deleteMetaData(_ key: String) -> Bool {
        switch self.type {
        case MediaType.image:
            if key != "creator" && key != "resolution" {
               return deleteKey(key)
            } else {
                return false
            }
        case MediaType.audio:
            if key != "creator" && key != "runtime" {
                return deleteKey(key)
            } else {
                return false
            }
        case MediaType.document:
            if key != "creator" {
                return deleteKey(key)
            } else {
                return false
            }
        case MediaType.video:
            if key != "creator" && key != "resolution" && key != "runtime" {
                return deleteKey(key)
            } else {
                return false
            }
        }
    }
    
    private func deleteKey(_ key: String) -> Bool {
        for index in 0..<metadata.count {
            if metadata[index].keyword == key{
                metadata.remove(at: index)
                return true
                
            }
        }
        return false
    }
}
