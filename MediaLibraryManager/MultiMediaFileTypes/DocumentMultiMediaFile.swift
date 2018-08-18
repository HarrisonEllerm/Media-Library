//
//  DocumentMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class DocumentMultiMediaFile: MultiMediaFile {
    
    var creatorMissing : Bool = false
    
    func isValid() -> Bool {
        var valid : Bool = true
        
        if !self.metadata.contains(where: { (metadata) -> Bool in
            if metadata.keyword == "creator" {
                return true
            }
            return false
        }) {
            self.creatorMissing = true
            valid = false
        }
       return valid
    }
    
    func getErrors() -> [String] {
        var errors = [String]()
        if creatorMissing {
            errors.append("'creator' missing")
        }
        return errors
    }
}
