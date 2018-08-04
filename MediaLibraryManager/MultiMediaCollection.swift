//
//  MultiMediaCollection.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 2/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaCollection : MMCollection {
    
    var collection: [MMMetadata]
    var metaDataCount: Int
    
    init() {
        collection = [MMMetadata]()
        metaDataCount = 0
    }
    
    func add(file: MMFile) {
        for item in file.metadata {
            collection.append(item)
            metaDataCount += 1
        }
    }
    
    func add(metadata: MMMetadata, file: MMFile) {
        //TODO checks against file type?
        collection.append(metadata)
    }
    
    func remove(metadata: MMMetadata) {
        //TODO improve this somehow
        for index in (0..<collection.count) {
            if (collection[index].keyword == metadata.keyword) &&
                (collection[index].value == metadata.keyword) {
                collection.remove(at: index)
            }
        }
    }
    
    func search(term: String) -> [MMFile] {
        <#code#>
    }
    
    func all() -> [MMFile] {
        <#code#>
    }
    
    func search(item: MMMetadata) -> [MMFile] {
        <#code#>
    }
    
    var description: String
    
    
    
    
    
}
