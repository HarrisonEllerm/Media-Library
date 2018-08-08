//
//  AudioMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class AudioMultiMediaFile: MultiMediaFile {
    
    var creatorMissing : Bool = false
    
    var runtimeMissing : Bool = false
    
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
        if !self.metadata.contains(where: { (m) -> Bool in
            if m.keyword == "runtime" {
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
        precondition(!isValid())
        var errors = [String]()
        if creatorMissing {
            errors.append("'creator' missing")
        }
        if runtimeMissing {
            errors.append("'runtime' missing")
        }
        return errors
    }
}
