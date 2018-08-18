//
//  MultiMediaCollection.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class MultiMediaCollection: MMCollection, MMCollectionDeleter {
    
    //MAYBE STATIC? TODO
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
    
    /**
        Adds metadata to a file, and then updates
        that file within the collection.
     
        - parameter : metadata, the metadata to be added.
        - parameter : file, the file that the metadata is to be added to.
     
        TODO: handle errors/find better way
    */
    func add(metadata: MMMetadata, file: MMFile) {
        if let upCastFile = file as? MultiMediaFile {
            upCastFile.metadata.append(metadata)
            self.replaceFile(file, upCastFile)
        } else {
            //Throw some kind of exception?
        }
    }
    
    func remove(metadata: MMMetadata) {
        
    }
    
    func removeMetadataWithKey(key: String, file: MMFile) -> Bool {
        if let upCastFile = file as? MultiMediaFile {
            let success = upCastFile.deleteMetaData(key)
            if success {
                self.replaceFile(file, upCastFile)
                //Metadata successfully deleted
                return true
            }
        }
        //Could not delete metadata (might not exist)
        return false
    }
    
    func search(term: String) -> [MMFile] {
        return [MMFile]()
    }
    
    func all() -> [MMFile] {
        return collection
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

extension MultiMediaCollection {
    
    func containsFile(fileUrl: String) -> Bool {
        return self.collection.contains(where: { (mmfile) -> Bool in
            if mmfile.path == fileUrl {
                return true
            }
            return false
        })
    }
    
    func getFile(fileUrl: String) -> MMFile? {
        for item in self.collection {
            if item.path == fileUrl {
                return item
            }
        }
        return nil
    }
    
    func replaceFile(_ file: MMFile, _ upCastFile: MultiMediaFile) {
        for var item in self.collection {
            if item.path == file.path {
                item = upCastFile
            }
        }
    }
}

