//
//  cli.swift
//  MediaLibraryManager
//  COSC346 S2 2018 Assignment 1
//
//  Created by Paul Crane on 21/06/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//
import Foundation

/// The list of exceptions that can be thrown by the CLI command handlers
enum MMCliError: Error {
    
    /// Thrown if there is something wrong with the input parameters for the
    /// command
    case invalidParameters
    
    /// Thrown if there is no result set to work with (and this command depends
    /// on the previous command)
    case missingResultSet
    
    /// Thrown when the command is not understood
    case unknownCommand
    
    /// Thrown if the command has yet to be implemented
    case unimplementedCommand
    
    /// Thrown if there is no command given
    case noCommand
    
    /// Thrown if the file being read in doesn't exist
    case invalidFile(String)
    
    /// Thrown if the file being read cannot be parsed
    case couldNotParse
    
    /// Thrown if the json format of the file being read is wrong
    case couldNotDecode
    
    /// Thrown if the format for the add function is invalid
    case addDelFormatIncorrect
    
    /// Thrown if the add function could not locate the file
    case addCouldNotLocateFile(Int)
    
    ///Thrown if the File is not passed in
    case saveMissingFileName()
    
    ///Thrown if the directory does not exist
    case saveDirectoryError
    
    ///Thrown if the encoder failed to encode the data
    case couldNotEncodeException
    
    ///Thrown if the collection is empty
    case libraryEmpty
    
    //Thrown if the key being set doesn't exist
    case setKeyDidNotExist(String)
    
    //Thrown if the set format is incorrect
    case setFormatIncorrect
    
    //Thrown if del-all couldn't delete metadata from every file in the collection
    case delAllCouldntModifyAllFiles(Int)
    
    //Thrown if a delete is not allowed
    case delNotAllowedError
    
    //Thrown if the del-all command format is incorrect
    case delAllFormatIncorrect
   
}

/// Generate a friendly prompt and wait for the user to enter a line of input
/// - parameter prompt: The prompt to use
/// - parameter strippingNewline: Strip the newline from the end of the line of
///   input (true by default)
/// - return: The result of `readLine`.
/// - seealso: readLine
func prompt(_ prompt: String, strippingNewline: Bool = true) -> String? {
    // the following terminator specifies *not* to put a newline at the
    // end of the printed line
    print(prompt, terminator:"")
    return readLine(strippingNewline: strippingNewline)
}

/// This class representes a set of results.
class MMResultSet{
    
    /// The list of files produced by the command
    private var results: [MMFile]
    
    /// Constructs a new result set.
    /// - parameter results: the list of files produced by the executed
    /// command, could be empty.
    init(_ results:[MMFile]){
        self.results = results
    }
    /// Constructs a new result set with an empty list.
    convenience init(){
        self.init([MMFile]())
    }
    
    /// If there are some results to show, enumerate them and print them out.
    /// - note: this enumeration is used to identify the files in subsequent
    /// commands.
    func showResults(){
        guard self.results.count > 0 else{
            return
        }
        for (i,file) in self.results.enumerated() {
            print("\(i): \(file)")
        }
    }
    
    /// Determines if the result set has some results.
    /// - returns: True iff there are results in this set
    func hasResults() -> Bool{
        return self.results.count > 0
    }
    
    ///Returns a File from the MMResult Set at the specified index.
    /// - parameter Index: The index of the file we are looking to retrun.
    func getFileAtIndex(index: Int) -> MMFile? {
        if index < results.count{
            return results[index]
        }else{
            return nil
        }
    }
    
    ///Returns all of the files stored within set.
    /// - returns: an array of MMFile
    func getAllFiles() -> [MMFile] {
        return self.results
    }
}

///A struct used to represent the structure
///of the json files being read in as input.
struct Media : Codable {
    var fullpath: String
    var type : MediaType
    var metadata : [String: String]
}

/// The interface for the command handler.
protocol MMCommandHandler{
    
    /// The handle function executes the command.
    ///
    /// - parameter params: The list of parameters to the command. For example,
    /// typing 'load foo.json' at the prompt will result in params containing
    /// *just* the foo.json part.
    ///
    /// - parameter last: The previous result set, used to give context to some
    /// of the commands that add/set/del the metadata associated with a file.
    ///
    /// - Throws: one of the `MMCliError` exceptions
    ///
    /// - returns: an instance of `MMResultSet`
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet;
    
}

/// Handles the 'help' command -- prints usage information
/// - Attention: There are some examples of the commands in the source code
/// comments
class HelpCommandHandler: MMCommandHandler{
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet{
        print("""
\thelp                              - this text
\tload <filename> ...               - load file into the collection
\tlist <term> ...                   - list all the files that have the term specified
\tlist                              - list all the files in the collection
\tadd <number> <key> <value> ...    - add some metadata to a file
\tset <number> <key> <value> ...    - this is really a del followed by an add
\tdel <number> <key> ...            - removes a metadata item from a file
\tdel-all <key> ...                 - removes a metadata item from every file in the collection.
\tsave-search <filename>            - saves the last list results to a file
\tsave <filename>                   - saves the whole collection to a file
\tquit                              - quit the program
""")
        return last
    }
}

/// Handle the 'clear' command
/// Just an easy way to create some clear space on the console
class ClearCommandHandler: MMCommandHandler{
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        for _ in 1...100 {
            puts(" ")
        }
        return last
    }
}

/// Handle the 'quit' command
class QuitCommandHandler : MMCommandHandler {
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        // you may want to prompt if the previous result set hasn't been saved...
        exit(0)
    }
}

// All the other commands are unimplemented
class UnimplementedCommandHandler: MMCommandHandler{
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}

///Handle the 'load' command
class LoadCommandHandler: MMCommandHandler{
   
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
    
        var garbage = [MMFile]()
        let decoder = JSONDecoder()
        var validFileCount = 0
     
        for item in params {
            // Parse the command to replace '~' with home directory
            let path = CommandLineParser.sharedInstance.getCommand(inputString: item)
            
            //Check that the file actually exists before continuing
            if FileManager.default.fileExists(atPath: path) {
                
                if let data = try String(contentsOfFile: path).data(using: .utf8) {
                    
                    do {
                        let media : [Media] = try decoder.decode([Media].self, from: data)
                        for item in media {
                            
                            let fileName = URL(fileURLWithPath: path).lastPathComponent
                            var metaData = [MultiMediaMetaData]()
                            for data in item.metadata {
                                let metaDataItem = MultiMediaMetaData(keyword: data.key, value: data.value)
                                metaData.append(metaDataItem)
                            }
                            let file = getMultiMedaiFile(fileName, metaData, item)
                            
                            //If file is valid and is not already in the library
                            if file.1 && !library.containsFile(fileUrl: file.0.path){
                                library.add(file: file.0)
                                validFileCount += 1
                            } else {
                                garbage.append(file.0)
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
            //File did not exist at the location specificed
            } else {
                throw MMCliError.invalidFile(path)
            }
        }
        print("Successfully imported \(validFileCount) file(s)")
        if(garbage.count > 0) {
           handleGarbage(garbage)
        }
        return MMResultSet()
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
}

class ListCommandHandler: MMCommandHandler {
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        //If there is nothing in the library
        if library.collection.isEmpty {
            throw MMCliError.libraryEmpty
        //If they just want to see everything in the library
        } else if params.count == 0 {
            return MMResultSet(library.all())
        } else {
            //Searching for one or more keywords
            var searchList = [MMFile]()
            for searchTerm in params {
                
                let resultOfSearch = library.search(term: searchTerm)
                for item in resultOfSearch {
                    if !searchList.contains(where: { (file) -> Bool in
                        if file.path == item.path {
                            return true
                        }
                        return false
                    }) {
                        searchList.append(item)
                    }
                }
            }
            return MMResultSet(searchList)
        }
    }
}

class AddCommandHandler: MMCommandHandler{
    
    //Minimum number of params acceptable for command
    private let minParams = 3
    
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
    //Check format before we even try to do anything
        if CommandLineParser.sharedInstance.validFormat(params, minParams) {
            //This is safe as already validated it exists
            let indexToFile = Int(params[0])!
            let seq = stride(from: 2, to: params.count, by: 2)
            for item in seq {
                if let file = last.getFileAtIndex(index: indexToFile) {
                    if (item < params.count) {
                        let meta = MultiMediaMetaData(
                            keyword: params[item-1].trimmingCharacters(in: .whitespaces),
                            value: params[item].trimmingCharacters(in: .whitespaces))
                        library.add(metadata: meta, file: file)
                    }
                } else {
                    throw MMCliError.addCouldNotLocateFile(indexToFile)
                }
            }
        } else {
            throw MMCliError.addDelFormatIncorrect
        }
        return MMResultSet(library.all())
    }
}

class SetCommandHandler: MMCommandHandler{
    //Minimum number of params acceptable for command
    private let minParams = 3
    
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        //Check format before we even try to do anything
        if CommandLineParser.sharedInstance.validFormat(params, minParams) {
            //This is safe as already validated it exists
            let indexToFile = Int(params[0])!
            let seq = stride(from: 1, to: params.count, by: 2)
            for item in seq {
                if let file = last.getFileAtIndex(index: indexToFile) {
                    if (item < params.count) {
                        let keyToDelete = params[item]
                            let result = library.removeMetadataWithKey(key: keyToDelete, file: file)
                            if result {
                                let meta = MultiMediaMetaData(
                                    keyword: params[item].trimmingCharacters(in: .whitespaces),
                                    value: params[item+1].trimmingCharacters(in: .whitespaces))
                                    library.add(metadata: meta, file: file)
                                } else {
                                    throw MMCliError.setKeyDidNotExist(params[item])
                                }
                            }
                        } else {
                            throw MMCliError.addCouldNotLocateFile(indexToFile)
                        }
                    }
                } else {
                    throw MMCliError.setFormatIncorrect
                }
            return MMResultSet(library.all())
        }
}

class DelCommandHandler: MMCommandHandler{
    //Minimum number of params acceptable for command
    private let minParams = 2
    
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        //Check format before we even try to do anything
        if CommandLineParser.sharedInstance.validFormat(params, minParams) {
            //This is safe as already validated it exists
            let indexToFile = Int(params[0])!
            let seq = stride(from: 1, to: params.count, by: 1)
            for item in seq {
                if let file = last.getFileAtIndex(index: indexToFile) {
                    if (item < params.count) {
                        let keyToDelete = params[item]
                        let deleteOk = library.removeMetadataWithKey(key: keyToDelete, file: file)
                        if !deleteOk {
                            throw MMCliError.delNotAllowedError
                        }
                    }
                } else {
                    throw MMCliError.addCouldNotLocateFile(indexToFile)
                }
            }
        } else {
            throw MMCliError.addDelFormatIncorrect
        }
        return MMResultSet(library.all())
    }
}

class DelAllCommandHandler: MMCommandHandler{
    
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        //Number of succesfully deleted instances
        var successCount = 0
        //Number of uncessfully deleted instances
        var failCount = 0
        
        if params.count > 0 {
            let seq = stride(from: 0, to: params.count, by: 1)
            for item in seq {
                for file in library.all(){
                    let result = library.removeMetadataWithKey(key: params[item], file: file)
                    if result {
                        successCount += 1
                    } else {
                        failCount += 1
                    }
                }
            }
            if successCount > 0 {
                print("Sucessfully deleted \(successCount) metadata instances.")
            }
            if failCount > 0 {
                throw MMCliError.delAllCouldntModifyAllFiles(failCount)
            }
        //At least one argument needed to issue del-all command
        } else {
            throw MMCliError.delAllFormatIncorrect
        }
        return MMResultSet(library.all())
    }
}

class SaveCommandHandler: MMCommandHandler{
    
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
        var encodeableArray = [Media]()
        
        if params.count == 1 {
            for file in library.all(){
                var meta = [String:String]()
                for item in file.metadata {
                    meta.updateValue(item.keyword, forKey: item.value)
                }
            let mediaStruct = Media(fullpath: file.path, type: file.type, metadata: meta)
            encodeableArray.append(mediaStruct)
        }
        //Get the documents directory for the user
        if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            var filename = params[0]
            //If the user didn't save it as a json file make it one
            if !filename.contains(".json"){
                filename.append(".json")
            }
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
    //User didn't specify a file name to save it as
    } else {
        throw MMCliError.saveMissingFileName()
    }
    return MMResultSet()
    }
}

class SaveSearchCommandHandler: MMCommandHandler{
    func handle(_ params: [String], last: MMResultSet, library: MultiMediaCollection) throws -> MMResultSet {
         var array = [Media]()
        if params.count == 1 {
            let seq = stride(from: 0, to: last.getAllFiles().count, by: 1)
            for item in seq {
                if let file = last.getFileAtIndex(index: item) {
                    print("FILENAME = \(file.filename)")
                    var meta = [String:String]()
                    for item in file.metadata {
                        
                        meta.updateValue(item.keyword, forKey: item.value)
                    }
                    let mediaStruct = Media(fullpath: file.path, type: file.type, metadata: meta)
                    array.append(mediaStruct)
                }
              
            }
            print("ARRAY \(array.description)")
            if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                var filename = params[0]
                
                    if !filename.contains(".json"){
                        filename.append(".json")
                    }
                    
                    let directory = documentsURL.appendingPathComponent(filename)
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(array)
                        
                        //let data = try JSONSerialization.data(withJSONObject: array, options: [])
                        try jsonData.write(to: directory, options: [])
                        print("Successfully saved the file.")
                        
                    } catch {
                        
                        throw MMCliError.couldNotEncodeException
                    }
                
            }else{
                throw MMCliError.saveDirectoryError
            }
        
        }else{
            throw MMCliError.saveMissingFileName()
        }
        return MMResultSet()
    }
}

///
/// A class that contains various convenience functions
/// used to handle user command line input.
///
/// Implements the Singleton design pattern.
///
class CommandLineParser {
    
    static let sharedInstance = CommandLineParser()
    
    private init() {}
    
    func getCommand(inputString: String) -> String {
        if (inputString.contains("~")) {
           let path = inputString.replacingOccurrences(of: "~", with: NSString(string: "~").expandingTildeInPath)
            return path
        } else {
            return inputString
        }
    }
    
    /**
     Quick sanity check used for some commands,
     that makes sure the first item is a number and that
     there is minimum number of arguments provided.
     
        i.e. add '0 foo bar'
        i.e. set '0 foo bar'
     
     - parameter : params, the parameters passed in as args to add.
     - returns: a boolean representing if the format of the args is correct.
     */
    func validFormat(_ params: [String], _ numberOfParams: Int) -> Bool {
        //Minimum amount of args is 3 and first is a number (file number)
        if params.count >= numberOfParams && (Int(params[0]) != nil) {
            return true
        }
        return false
    }
}
