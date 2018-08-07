//
//  DocumentMultiMediaFile.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 8/7/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class DocumentMultiMediaFile: MultiMediaFile {
    
    func isValid() -> Bool {
        if self.metadata.contains(where: { (metadata) -> Bool in
            if metadata.keyword == "creator" {
                return true
            }
            return false
        })
        {
            return true
        } else {
            return false
        }
    }
}
