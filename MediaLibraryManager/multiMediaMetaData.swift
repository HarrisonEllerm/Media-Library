//
//  MultiMediaMetaData.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 2/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaMetaData : MMMetadata {
    //The keyword associated with the metadata
    var keyword: String
    //the value associated with the metadata
    var value: String
    
    var description: String {
        get {
            return "\(keyword):\(value)"
        }
    }
    
    init(keyword: String, value: String) {
        self.keyword = keyword
        self.value = value
    }
    
}
