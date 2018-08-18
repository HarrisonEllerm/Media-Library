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
}
