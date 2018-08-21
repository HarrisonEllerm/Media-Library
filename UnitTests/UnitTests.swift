//
//  UnitTests.swift
//  UnitTests
//
//  Created by Harrison Ellerm on 11/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import XCTest

@testable import MediaLibraryManager

class UnitTests: XCTestCase {
    
    var testBundle: Bundle!
    var loadHandler: LoadCommandHandler!
    var addHandler: AddCommandHandler!
    var listHandler: ListCommandHandler!
    var setHandler: SetCommandHandler!
    var delHandler: DelCommandHandler!
    var delAllHandler: DelAllCommandHandler!
    var saveHandler: SaveCommandHandler!
    var testLib: MultiMediaCollection!

    override func setUp() {
        super.setUp()
        testBundle = Bundle(for: type(of: self))
        loadHandler = LoadCommandHandler()
        addHandler = AddCommandHandler()
        listHandler = ListCommandHandler()
        setHandler = SetCommandHandler()
        delHandler = DelCommandHandler()
        delAllHandler = DelAllCommandHandler()
        saveHandler = SaveCommandHandler()
        testLib = MultiMediaCollection()
    }

    override func tearDown() {
        super.tearDown()
    }

    /**
        Tests completely invalid image files, where both 'files'
        missing creator and resolution.
     
        - Expectation: invalid image files will NOT be added to
                       the library.
    */
    func testInvalidImageFile() {
        let fileUrl = testBundle.url(forResource: "badImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badImageFile1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badImageFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
    /**
        Tests partially invalid image files, where one file
        is missing creator and the other resolution.
     
        - Expectation: partially invalid image files will NOT be added to
                       the library.
     */
    func testSemiInvalidImageFile() {
        let fileUrl = testBundle.url(forResource: "semiBadImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                 XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadImageFile1.json"))
                 XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadImageFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely valid image files, where both include
        both a creator and resolution field.
     
        - Expectation: valid image files WILL be added to
                       the library.
     */
    func testValidImageFile() {
        let fileUrl = testBundle.url(forResource: "goodImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodImageFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodImageFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely invalid video files, where both 'files'
        missing creator, resolution and runtime.
     
        - Expectation: invalid video files will NOT be added to
                       the library.
     */
    func testInvalidVideoFile() {
        let fileUrl = testBundle.url(forResource: "badVideoFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badVideoFile1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badVideoFile2.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badVideoFile3.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests partially invalid video files, where one file
        is missing creator, one is missing resolution and another
        is missing runtime.
     
        - Expectation: partially invalid video files will NOT be added to
                       the library.
     */
    func testSemiInvalidVideoFile() {
        let fileUrl = testBundle.url(forResource: "semiBadVideoFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadVideoFile1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadVideoFile2.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadVideoFile3.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }

        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely valid video files, where all include a
        creator, runtime and resolution field.
     
        - Expectation: valid video files WILL be added to
                       the library.
     */
    func testValidVideoFile() {
        let fileUrl = testBundle.url(forResource: "goodVideoFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodVideoFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodVideoFile2.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodVideoFile3.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely invalid document file, where both files are
        missing the required field creator.
     
        - Expectation: invalid document files will NOT be added to
                       the library.
     */
    func testInvalidDocumentFile() {
        let fileUrl = testBundle.url(forResource: "badDocumentFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badDocumentFile1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badDocumentFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }

        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely valid document files, where all include a
        the required field creator.
     
        - Expectation: valid document files WILL be added to
                       the library.
     */
    func testValidDocumentFile() {
        let fileUrl = testBundle.url(forResource: "goodDocumentFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodDocumentFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodDocumentFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely invalid audio files, where both 'files'
        missing creator and runtime.
     
        - Expectation: invalid audio files will NOT be added to
                       the library.
     */
    func testInvalidAudioFile() {
        let fileUrl = testBundle.url(forResource: "badAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile1_1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile1_2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }

        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests partially invalid audio files, where one file
        is missing creator and the other runtime.
     
        - Expectation: partially invalid audio files will NOT be added to
                       the library.
     */
    func testSemiInvalidAudioFile() {
        let fileUrl = testBundle.url(forResource: "semiBadAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadAudio1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/semiBadAudio2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }

        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests completely valid audio files, where both include
        both a creator and runtime field.
     
        - Expectation: valid audio files WILL be added to
                       the library.
     */
    func testValidAudioFile() {
        let fileUrl = testBundle.url(forResource: "goodImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodImageFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodImageFile2.json"))
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        Tests that multiple valid Json files were loaded and merged correctly.
     
        - Expectation: valid audio files WILL be added to
                       the library and merged.
    */
    func testMultipleAudioFiles() {
        let fileUrl1 = testBundle.url(forResource: "goodAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        let fileUrl2 = testBundle.url(forResource: "goodAudioFile2",withExtension: ".json", subdirectory: "jsonFiles")

        if let relPath = fileUrl1?.relativePath, let relPath2 = fileUrl2?.relativePath {
                do {
                    let _ = try loadHandler.handle([relPath, relPath2], last: MMResultSet(), library: testLib)
                    XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1_1.json"))
                    XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1_2.json"))
                    XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2_1.json"))
                    XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2_2.json"))
                } catch(let error) {
                    XCTFail("An exception was raised \(error.localizedDescription)")
                }
            } else {
                XCTFail("Failed to find file in directory")
            }
        }


    /**
        Tests that multiple invalid Json files were not loaded.
     
        - Expectation: invalid audio files WILL be added to
                       the library and not merged.
     */
    func testMultipleInvalidAudioFiles() {
        let fileUrl1 = testBundle.url(forResource: "badAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        let fileUrl2 = testBundle.url(forResource: "badAudioFile2",withExtension: ".json", subdirectory: "jsonFiles")
        
        if let relPath = fileUrl1?.relativePath, let relPath2 = fileUrl2?.relativePath {
            do {
                let _ = try loadHandler.handle([relPath, relPath2], last: MMResultSet(), library: testLib)
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile1_1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile1_2.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile2_1.json"))
                XCTAssert(!testLib.containsFile(fileUrl: "/somepath/badAudioFile2_2.json"))

            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

    /**
        This function tests that the add function works correctly.
        It loads in a file to modify, and then adds several metadata
        instances to it, finally testing if they were successfully added
        or not.
     
        This function mimics the way a user would add data. First, loading in
        a file to the library so they have something to modify. Then "Listing"
        the files so they can see which files exist at what index. Then passing
        in a index and new metadata, to add to a specific file.
     
        - Expectation: the files will be modified and contain the new
                       metadata.
    */
    func testAddMetadata() {
        let add1 = ["0", "Homer", "Simpson"]
        let add2 = ["1", "Peter", "Griffin", "Meg", "Griffin"]
        
        let fileUrl = testBundle.url(forResource: "addTestFile1", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                //First load the json file into the lib so we can modify it
                let load = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2.json"))
                
                //Now List the files in the library like a user would
                let list = try listHandler.handle([], last: load, library: testLib)
                
                //Add to the first file
                let result = try addHandler.handle(add1, last: list, library: testLib)
                
                //Check first file contains new metadata
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
                
                //Add to the second file
                let _ = try addHandler.handle(add2, last: result, library: testLib)
                
                //Check second file contains new metadata
                if let file2 = testLib.getFile(fileUrl: "/somepath/goodAudioFile2.json") as? MultiMediaFile {
                    
                    XCTAssert(file2.containsMetaData(meta: MultiMediaMetaData(keyword: "Peter", value: "Griffin")))
                    XCTAssertTrue(file2.containsMetaData(meta: MultiMediaMetaData(keyword: "Meg", value: "Griffin")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
    /**
        This function tests that the set function works correctly.
        It loads in a file to modify, and then adds a metadata
        instance to it, finally setting the value of that instance to be
        different from what it was initially, to test if the instance was
        successfully modified or not.
     
        - Expectation: the metadata that is initialy added ["Homer":"Simpson"]
                       will be set to ["Homer":"Griffin"].
     */
    func testSetMetadata() {
        let add1 = ["0", "Homer", "Simpson"]
        let set2 = ["0", "Homer", "Griffin"]
        
        let fileUrl = testBundle.url(forResource: "addTestFile1", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                //First load the json file into the lib so we can modify it
                let load = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2.json"))
                
                //Now List the files in the library like a user would
                let list = try listHandler.handle([], last: load, library: testLib)
                
                //Add to the first file
                let result = try addHandler.handle(add1, last: list, library: testLib)
                //Check first file contains new metadata
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
                //Now modify the new metadata
                let _ = try setHandler.handle(set2, last: result, library: testLib)
                //Check first files metadata has been modified
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Griffin")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
    /**
        This function tests that the del function works correctly.
        It loads in a file to modify, and then adds a metadata
        instance to it, then finally deleting that instance to
        ensure that the delete function works as expected.
     
        - Expectation: the metadata that is initialy added ["Homer":"Simpson"]
                       will be deleted.
     */
    func testDelMetadata() {
        let add1 = ["0", "Homer", "Simpson"]
        let del1 = ["0", "Homer"]
        
        let fileUrl = testBundle.url(forResource: "addTestFile1", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                //First load the json file into the lib so we can modify it
                let load = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2.json"))
                
                //Now List the files in the library like a user would
                let list = try listHandler.handle([], last: load, library: testLib)
                
                //Add to the first file
                let result = try addHandler.handle(add1, last: list, library: testLib)
                //Check first file contains new metadata
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
                //Now delete the new metadata
                let _ = try delHandler.handle(del1, last: result, library: testLib)
                //Check first files metadata has been modified
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(!file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
    func testDelAllMetadata() {
        let add1 = ["0", "Homer", "Simpson"]
        let add2 = ["1", "Homer", "Simpson"]
        let del = ["Homer"]
   
        let fileUrl = testBundle.url(forResource: "addTestFile1", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                //First load the json file into the lib so we can modify it
                let load = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2.json"))
                
                //Now List the files in the library like a user would
                let list = try listHandler.handle([], last: load, library: testLib)
                
                //Add to the first file
                let result = try addHandler.handle(add1, last: list, library: testLib)
                //Check first file contains new metadata
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile {
                    XCTAssert(file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
                
                //Add to the second file
                let result2 = try addHandler.handle(add2, last: result, library: testLib)
                //Check second file contains new metadata
                if let file2 = testLib.getFile(fileUrl: "/somepath/goodAudioFile2.json") as? MultiMediaFile {
                    XCTAssert(file2.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
                
                //Now delete the new metadata from all files
                let _ = try delAllHandler.handle(del, last: result2, library: testLib)
                //Check first files metadata has been modified
                if let file1 = testLib.getFile(fileUrl: "/somepath/goodAudioFile1.json") as? MultiMediaFile,
                    let file2 = testLib.getFile(fileUrl: "/somepath/goodAudioFile2.json") as? MultiMediaFile {
                    XCTAssert(!file1.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                    XCTAssert(!file2.containsMetaData(meta: MultiMediaMetaData(keyword: "Homer", value: "Simpson")))
                } else {
                    XCTFail("Failed to upcast/failed to find metadata")
                }
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
    func testSaveMetaData() {
        let save = ["test"]
        
        let fileUrl = testBundle.url(forResource: "addTestFile1", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                //First load the json file into the lib so we can modify it
                let load = try loadHandler.handle([relPath], last: MMResultSet(), library: testLib)
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile1.json"))
                XCTAssert(testLib.containsFile(fileUrl: "/somepath/goodAudioFile2.json"))
                
                //Now List the files in the library like a user would
                let list = try listHandler.handle([], last: load, library: testLib)
                
                //Save the library
                let _ = try saveHandler.handle(save, last: list, library: testLib)
                
                //Check file exists in users documents directory
                if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let url = documents.appendingPathComponent("/test.json")
                    XCTAssert(FileManager.default.fileExists(atPath: url.path))
                }
              
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }
    
}
