//
//  VideoMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class VideoMultiMediaFile: MultiMediaFile {
    
    var creatorMissing : Bool = false
    
    var resolutionMissing : Bool = false
    
    var runtimeMissing : Bool = false
 
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
        if !self.metadata.contains(where: { (metadata) -> Bool in
            if metadata.keyword == "resolution" {
                return true
            }
            return false
        }) {
            self.resolutionMissing = true
            valid = false
        }
        
        if !self.metadata.contains(where: { (metadata) -> Bool in
            if metadata.keyword == "runtime" {
                return true
            }
            return false
        }) {
            self.runtimeMissing = true
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
            errors.append("'resolution' missing")
        }
        if runtimeMissing {
            errors.append("'runtime' missing")
        }
        return errors
    }
}
