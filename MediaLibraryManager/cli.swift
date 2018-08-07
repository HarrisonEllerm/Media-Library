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
}

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
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet;
    
}

/// Handles the 'help' command -- prints usage information
/// - Attention: There are some examples of the commands in the source code
/// comments
class HelpCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet{
        print("""
\thelp                              - this text
\tload <filename> ...               - load file into the collection
\tlist <term> ...                   - list all the files that have the term specified
\tlist                              - list all the files in the collection
\tadd <number> <key> <value> ...    - add some metadata to a file
\tset <number> <key> <value> ...    - this is really a del followed by an add
\tdel <number> <key> ...            - removes a metadata item from a file
\tsave-search <filename>            - saves the last list results to a file
\tsave <filename>                   - saves the whole collection to a file
\tquit                              - quit the program
""")
        return MMResultSet()
    }
}

/// Handle the 'quit' command
class QuitCommandHandler : MMCommandHandler {
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        // you may want to prompt if the previous result set hasn't been saved...
        exit(0)
    }
}

// All the other commands are unimplemented
class UnimplementedCommandHandler: MMCommandHandler {
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}

class LoadCommandHandler: MMCommandHandler {
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        
        //Note to self -> CommandLineParser and decoder could be Singleton
        
        var files = [MMFile]()
        let decoder = JSONDecoder()
        
        for item in params {
        
            // Parse the command to replace '~' with home directory
            let path = CommandLineParser.getCommand(inputString: item)
            
            //Check that the file actually exists before continuing
            if FileManager.default.fileExists(atPath: path) {
                
                if let data = try String(contentsOfFile: path).data(using: .utf8) {
              
                    let media : [Media] = try! decoder.decode([Media].self, from: data)
                    for item in media {
                        let fileName = URL(fileURLWithPath: path).lastPathComponent
                        var metaData = [MultiMediaMetaData]()
                        for data in item.metadata {
                            let metaDataItem = MultiMediaMetaData(keyword: data.key, value: data.value)
                            metaData.append(metaDataItem)
                        }
                        let file = MultiMediaFile(metadata: metaData, filename: fileName, path: item.fullpath, type: item.type)
                        files.append(file)
                        
                    }
                } else {
                    throw MMCliError.couldNotParse
                }
            
            } else {
                throw MMCliError.invalidFile(path)
            }
        }
        throw MMCliError.unimplementedCommand
    }
}
class ListCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
         throw MMCliError.unimplementedCommand
    }
   

}
class LastCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
    
    
}
class AddCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
    
    
}
class SetCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}


class DelCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}

class SaveCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}

class SaveSearchCommandHandler: MMCommandHandler{
    static func handle(_ params: [String], last: MMResultSet) throws -> MMResultSet {
        throw MMCliError.unimplementedCommand
    }
}

///
/// A class used to allow quick parsing of command line
/// arguments, replacing paths with a '~' character with
/// the users home directory
///
class CommandLineParser{
    static func getCommand(inputString: String) -> String {
        if (inputString.contains("~")) {
           let path = inputString.replacingOccurrences(of: "~", with: NSString(string: "~").expandingTildeInPath)
            return path
        } else {
            return inputString
        }
    }
}



