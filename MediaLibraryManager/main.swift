//
//  main.swift
//  MediaLibraryManager
//
//  Created by Paul Crane on 18/06/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import Foundation

// TODO create your instance of your library here
var lib = MultiMediaCollection()
var last = MMResultSet()

// The while-loop below implements a basic command line interface. Some
// examples of the (intended) commands are as follows:
//
// load foo.json bar.json
//  from the current directory load both foo.json and bar.json and
//  merge the results
//
// list foo bar baz
//  results in a set of files with metadata containing foo OR bar OR baz
//
// add 3 foo bar
//  using the results of the previous list, add foo=bar to the file
//  at index 3 in the list
//
// add 3 foo bar baz qux
//  using the results of the previous list, add foo=bar and baz=qux
//  to the file at index 3 in the list
//
// Feel free to extend these commands/errors as you need to.
while let line = prompt("> ") {
    var command: String = ""
    var parts = line.split(separator: " ").map({ String($0) })
    var showLast = true

    do {
        guard parts.count > 0 else {
            throw MMCliError.noCommand
        }
        command = parts.removeFirst();

        switch(command) {

        case "load":
            last = try LoadCommandHandler().handle(parts, last: last, library: lib)

        case "list":
            last = try ListCommandHandler().handle(parts, last: last, library: lib)

        case "add":
            last = try AddCommandHandler().handle(parts, last: last, library: lib)
            break

        case "set":
            last = try SetCommandHandler().handle(parts, last: last, library: lib)
            break

        case "del":
            last = try DelCommandHandler().handle(parts, last: last, library: lib)
            break
//        case "del-all":
//            last = try DelAllCommandHandler().handle(parts, last: last, library: lib)
//            break

        case "save":
            last = try SaveCommandHandler().handle(parts, last: last, library: lib)
            break

        case "save-search":
            last = try SaveSearchCommandHandler().handle(parts, last: last, library: lib)
            break

        case "help":
            last = try HelpCommandHandler().handle(parts, last: last, library: lib)
            showLast = false
            break

        case "clear":
            last = try ClearCommandHandler().handle(parts, last: last, library: lib)
            break

        case "quit":
            last = try QuitCommandHandler().handle(parts, last: last, library: lib)
            continue

        default:
            throw MMCliError.unknownCommand
        }
        if showLast {
            last.showResults()
        }

    } catch MMCliError.noCommand {
        print("No command given -- see \"help\" for details.")
    } catch MMCliError.unknownCommand {
        print("Command \"\(command)\" not found -- see \"help\" for details.")
    } catch MMCliError.invalidParameters {
        print("Invalid parameters for \"\(command)\" -- see \"help\" for details.")
    } catch MMCliError.unimplementedCommand {
        print("The \"\(command)\" command is not implemented.")
    } catch MMCliError.missingResultSet {
        print("No previous results to work from.")
    } catch MMCliError.invalidFile(let fileName) {
        print("File \(URL(fileURLWithPath: fileName).lastPathComponent) not found.")
    } catch MMCliError.couldNotParse {
        print("Could not successfully parse the file, please check your JSON.")
    } catch MMCliError.couldNotDecode {
        print("Could not decode the json file. Please ensure it follows the expected format:")
        print("[ \n {\n")
        print("""
                "fullpath": "/path/to/foobar.ext",\n"type": "image|video|document|audio",
              """)
        print("""
                "metadata": {\n  "key1": "value1",\n  "key2": "value1",\n  "...": "..."
              """)
        print("    }\n },\n...\n]")
    } catch MMCliError.addDelFormatIncorrect {
        print("Could not add/del due to incorrect syntax, please follow:")
        print("""
                    > 'add 3 foo bar'
                    > 'add 3 foo bar baz qux...'
                    > 'del 0 foo'
                    > 'del 0 foo baz...'
              """)
        print("Use del-all to remove metadata from all files.")
    } catch MMCliError.addCouldNotLocateFile(let indexToFile) {
        print("Could not locate file at index \(indexToFile) to add metadata to.")
    } catch MMCliError.saveMissingFileName {
        print("Could not find the name of the file.")
    } catch MMCliError.saveDirectoryError {
        print("Could not find the users documents directory.")
    } catch MMCliError.couldNotEncodeException {
        print("Could not encode the data.")
    } catch MMCliError.libraryEmpty {
        print("The collection is empty.")
    } catch MMCliError.setKeyDidNotExist(let key) {
        print("<-------------------------- Set Error Log ------------------------->")
        print("     > Could not modify key '\(key)', key does not exist.")
        print("<------------------------------------------------------------------>")
    } catch MMCliError.setFormatIncorrect {
        print("Could not set due to incorrect syntax, please follow:")
        print("""
                    > 'set 0 foo bar'
                    > 'set 0 foo bar baz qux...'
              """)
    } catch MMCliError.delAllCouldntModifyAllFiles(let count) {
        print("<---------------------- Delete All Error Log ---------------------->")
        print("     > Could not modify \(count) metadata instances, either the key(s)")
        print("       did not exist in certain files, or deleting the key(s)")
        print("       would result files becoming invalid.")
        print("<------------------------------------------------------------------>")
    } catch MMCliError.delNotAllowedError {
        print("<------------------------ Delete Error Log ------------------------>")
        print("     > Could not modify file, either key does not exist,")
        print("       or deleting the key would result in an invalid file.")
        print("<------------------------------------------------------------------>")
    } catch MMCliError.delAllFormatIncorrect {
        print("Could not del-all to incorrect syntax, please follow:")
        print("""
                    > 'del-all 0 foo'
                    > 'del-all foo baz...'
              """)
    } catch MMCliError.loadCommandFormatInvalid {
        print("Could not load due to incorrect syntax, please follow:")
        print("""
                    > 'load /somedirectory/file.json'
                    > 'load file.json' {if file exists in current directory}
              """)
    }
}
