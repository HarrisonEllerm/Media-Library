//
//  MultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 30/07/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaFile : MMFile {
    
    var metadata: [MMMetadata]
    
    var filename: String
    
    var path: String
    
    var description: String
    
    init(metadata: [MMMetadata], filename: String, path: String, description: String) {
        self.metadata = metadata
        self.filename = filename
        self.path = path
        self.description = description
    }
    
}
