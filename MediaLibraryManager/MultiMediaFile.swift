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
    
    var isValid: Bool
    
    var description: String {
        get {
            return "MultiMediaFile[Path: \(path), Filename: \(filename), MediaType: \(type), Metadata: \(metadata)"
        }
    }
    
    init(metadata: [MMMetadata], filename: String, path: String, type: MediaType) {
        self.metadata = metadata
        self.filename = filename
        self.path = path
        self.type = type
        self.isValid = false
    }
}
