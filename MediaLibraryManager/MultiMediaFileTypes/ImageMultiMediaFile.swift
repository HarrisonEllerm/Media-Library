//
//  ImageMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class ImageMultiMediaFile: MultiMediaFile {
    
    var creatorMissing : Bool = false
    
    var resolutionMissing : Bool = false
    
    func isValid() -> Bool {
        var valid : Bool = true
        
        if !self.metadata.contains(where: { (m) -> Bool in
            if m.keyword == "creator" {
                return true
            }
            return false
        }) {
            self.creatorMissing = true
            valid = false
        }
        if !self.metadata.contains(where: ({ (m) -> Bool in
            if m.keyword  == "resolution" {
                return true
            }
            return false
        })) {
            self.resolutionMissing = true
            valid = false
        }
        return valid
    }
    
    func getErrors() -> [String] { 
        var errors = [String]()
        if creatorMissing {
            errors.append("'creator' missing")
        }
        if resolutionMissing {
            errors.append("'contents' missing")
        }
        return errors
    }
}
