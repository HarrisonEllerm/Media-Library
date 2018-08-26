//
//  exporter.swift
//  MediaLibraryManager
//
//
//
//  Created by Harrison Ellerm on 23/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class Exporter: MMFileExport {

    func write(filename: String, items: [MMFile]) throws {
        var encodeableArray = [Media]()

        for file in items {
            var meta = [String: String]()
            for item in file.metadata {
                meta.updateValue(item.keyword, forKey: item.value)
            }
            let mediaStruct = Media(fullpath: file.path, type: file.type, metadata: meta)
            encodeableArray.append(mediaStruct)
        }
        //Get the documents directory for the user
        if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let directory = documents.appendingPathComponent(filename)
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(encodeableArray)
                try jsonData.write(to: directory, options: [])
                print("Successfully saved the file to \(directory.path).")
            } catch {
                throw MMCliError.couldNotEncodeException
            }
            //Could not find users home directory
        } else {
            throw MMCliError.saveDirectoryError
        }
    }
}
