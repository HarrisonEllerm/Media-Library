//
//  MultiMediaCollection.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaCollection: MMCollection {
    
    var collection : [MMFile]
    var count : Int
    
    init() {
        collection = [MMFile]()
        count = 0
    }
    
    func add(file: MMFile) {
        collection.append(file)
        count += 1
    }
    
    func add(metadata: MMMetadata, file: MMFile) {
        
    }
    
    func remove(metadata: MMMetadata) {
        
    }
    
    func search(term: String) -> [MMFile] {
        return [MMFile]()
    }
    
    func all() -> [MMFile] {
        return [MMFile]()
    }
    
    func search(item: MMMetadata) -> [MMFile] {
        return [MMFile]()
    }
    
    var description: String {
        get {
            return ""
        }
    }

}
