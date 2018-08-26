//
//  commandLineParser.swift
//  MediaLibraryManager
//
// A class that contains various convenience functions
// used to handle user command line input. Implements
// the Singleton design pattern.
//
//  Created by Harrison Ellerm on 27/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

class CommandLineParser {

    static let sharedInstance = CommandLineParser()

    private init() { }

    ///
    /// A function used to parse the command line argument
    /// given by the user. If a user passes in the tilde argument
    /// it replaces that character with their home directory, or if
    /// they do no prefix the path with a '/', it appends the current
    /// directory to the beginning of the path they have defined.
    ///
    /// - parameter : inputString, the string passed into the CLI.
    /// - returns: a parsed string used to reference files within the
    ///            the users environment.
    ///
    func getCommand(inputString: String) -> String {
        //If the user prefixs with a tilde
        if (inputString.contains("~")) {
            return inputString.replacingOccurrences(of: "~", with: NSString(string: "~").expandingTildeInPath)
            //If the user doesn't prefix with a '/', therefore
            //they are trying to reference a file within the current directory.
        } else if (inputString.first != "/") {
            return FileManager.default.currentDirectoryPath
                + ("/" + inputString)
        } else {
            return inputString
        }
    }

    ///
    /// Quick sanity check used for some commands,
    /// that makes sure the first item is a number and that
    /// there is minimum number of arguments provided.
    ///
    /// i.e. add '0 foo bar'
    /// i.e. set '0 foo bar'
    ///
    /// - parameter : params, the parameters passed in as args to add.
    /// - returns: a boolean representing if the format of the args is correct.
    ///
    func validFormat(_ params: [String], _ numberOfParams: Int) -> Bool {
        //Minimum amount of args is 3 and first is a number (file number)
        if params.count >= numberOfParams && (Int(params[0]) != nil) {
            return true
        }
        return false
    }
}
