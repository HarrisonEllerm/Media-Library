//
//  MultiMediaMetaData.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 30/07/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaMetaData : MMMetadata {
    
    var keyword: String
    
    var value: String
    
    var description: String {
        get {
            return "Keyword: \(keyword) Value: \(value) Description: \(self.description)"
        }
        set(newDescription) {
            self.description = newDescription
        }
    }
    
    init(keyword: String, value: String, description: String) {
        self.keyword = keyword
        self.value = value
        self.description = description
    }
}
