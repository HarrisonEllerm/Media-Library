//
//  AudioMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class AudioMultiMediaFile: MultiMediaFile {
    
    ///Flag that represents if creator field is missing
    var creatorMissing : Bool = false
    
    ///Flag that represents if runtime field is missing
    var runtimeMissing : Bool = false
    
    /**
        A function that determines if the file is "valid". An
        image file is valid if:
     
        (i) the creator field exists
        (ii) the runtime field exists
     
        - returns: a Boolean representing if the file meets
                   the above criterea.
     */
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
    
    /**
        A function that investigates the errors associated
        with the file, so that these can be shown to the
        user in an intuitive way.
     
        - returns: A String array with the errors found.
     */
    func getErrors() -> [String] {
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
