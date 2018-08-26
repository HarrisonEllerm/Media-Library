//
//  Importer.swift
//  MediaLibraryManager
//
//  Created by Harrison Ellerm on 23/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class Importer: MMFileImport {
    
    static let sharedInstance = Importer()
    
    private init(){}

    ///
    /// Reads a file in and performs the necessary
    /// steps needed to parse the json into MMFile
    /// objects.
    ///
    /// - parameters: filename, the name of the file being read
    /// - returns: an array of MMFiles, the result of parsing
    ///               the file.
    ///
    func read(filename: String) throws -> [MMFile] {

        var files = [MMFile]()
        var garbage = [MMFile]()
        let decoder = JSONDecoder()
        var validFileCount = 0

        if let data = try String(contentsOfFile: filename).data(using: .utf8) {
            do {
                let media: [Media] = try decoder.decode([Media].self, from: data)
                for item in media {

                    let fileName = URL(fileURLWithPath: filename).lastPathComponent
                    var metaData = [MultiMediaMetaData]()
                    for data in item.metadata {
                        let metaDataItem = MultiMediaMetaData(keyword: data.key, value: data.value)
                        metaData.append(metaDataItem)
                    }
                    let fileTuple = getMultiMedaiFile(fileName, metaData, item)

                    //If file is valid and is not already in the library
                    if fileTuple.1 && !files.contains(where: { (file) -> Bool in
                        if file.path == fileTuple.0.path {
                            return true
                        }
                        return false
                    }) {
                        files.append(fileTuple.0)
                        validFileCount += 1
                    } else {
                        garbage.append(fileTuple.0)
                    }
                }
            } catch {
                //File existed, but json could not be decoded
                throw MMCliError.couldNotDecode
            }
            //File could not be parsed into a String using .utf8
        } else {
            throw MMCliError.couldNotParse
        }
        if validFileCount > 0 {
            print("Successfully imported \(validFileCount) file(s) from \(filename)")
        }
        if(garbage.count > 0) {
            handleGarbage(garbage)
        }
        return files
    }

    ///
    /// This function gets the appropriate media file for a given item inside the decoded JSON.
    /// It returns a tuple with the given file and a boolean value indicating if it was created
    /// with the correct metadata or not.
    ///
    /// - parameter : filename, a string representing the file name
    /// - parameter : metadata, the metadata that belongs to the item.
    /// - parameter : item, the actual media item
    ///
    /// - returns: a tuple containing the file created, and a boolean value.
    ///
    private func getMultiMedaiFile(_ filename: String, _ metadata: [MultiMediaMetaData], _ item: Media) -> (MultiMediaFile, Bool) {
        switch item.type {
        case MediaType.image:
            let file = ImageMultiMediaFile(metadata: metadata, filename: filename, path: item.fullpath, type: item.type)
            return (file, file.isValid())
        case MediaType.audio:
            let file = AudioMultiMediaFile(metadata: metadata, filename: filename, path: item.fullpath, type: item.type)
            return (file, file.isValid())
        case MediaType.document:
            let file = DocumentMultiMediaFile(metadata: metadata, filename: filename, path: item.fullpath, type: item.type)
            return (file, file.isValid())
        case MediaType.video:
            let file = VideoMultiMediaFile(metadata: metadata, filename: filename, path: item.fullpath, type: item.type)
            return (file, file.isValid())
        }
    }

    ///
    /// This function handles files which were not added to the result
    /// set as they violated the minimum metadata requirements for that
    /// particular file type. It handles the "garbage" by displaying to
    /// the user the file(s) that were not returned as part of the result
    /// set and why they were not returned.
    ///
    /// - parameter : contents, the garbage (collection of MMFiles)
    ///
    func handleGarbage(_ garbage: [MMFile]) {
        print("<------------------------ Import Error Log ------------------------>")
        print("\tThe following file(s) were ignored as part of the import:\n")
        for item in garbage {
            print("\(item.path):")
            switch item.type {

            case MediaType.image:
                if let imageFile = item as? ImageMultiMediaFile {
                    let errors = imageFile.getErrors()
                    if errors.isEmpty {
                        print("     > Duplicate file (path already exists)")
                    } else {
                        for err in errors {
                            print("     > \(err)")
                        }
                    }
                    print()
                }

            case MediaType.audio:
                if let audioFile = item as? AudioMultiMediaFile {
                    let errors = audioFile.getErrors()
                    if errors.isEmpty {
                        print("     > Duplicate file (path already exists)")
                    } else {
                        for err in errors {
                            print("     > \(err)")
                        }
                    }
                    print()
                }

            case MediaType.document:
                if let documentFile = item as? DocumentMultiMediaFile {
                    let errors = documentFile.getErrors()
                    if errors.isEmpty {
                        print("     > Duplicate file (path already exists)")
                    } else {
                        for err in errors {
                            print("     > \(err)")
                        }
                    }
                    print()
                }

            case MediaType.video:
                if let videoFile = item as? VideoMultiMediaFile {
                    let errors = videoFile.getErrors()
                    if errors.isEmpty {
                        print("     > Duplicate file (path already exists)")
                    } else {
                        for err in errors {
                            print("     > \(err)")
                        }
                    }
                }
                print()
            }
        }
        print("<------------------------------------------------------------------>")
    }
}
