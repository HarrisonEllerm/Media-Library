//
//  exporter.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 23/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class Exporter: MMFileExport {

    static let sharedInstance = Exporter()

    private init() { }

    ///
    /// Supports the exporting of multi-media files to disk.
    ///
    /// - parameter : filename, the name of the file being written.
    /// - parameter : items, the files being written.
    ///
    func write(filename: String, items: [MMFile]) throws {
        //Check they are exporting to a JSON file
        var actualFileName = filename
        if !filename.contains(".json") {
            actualFileName.append(".json")
        }
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
            let directory = documents.appendingPathComponent(actualFileName)
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
