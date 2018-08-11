//
//  UnitTests.swift
//  UnitTests
//
//  Created by Harrison Ellerm on 11/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import XCTest

@testable import MediaLibraryManager

class LoadCommandUnitTests: XCTestCase {
    
    var testBundle: Bundle!
    var loadHandler: LoadCommandHandler!
    
    override func setUp() {
        super.setUp()
        testBundle = Bundle(for: type(of: self))
        loadHandler = LoadCommandHandler()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
        Tests completely invalid image files, where both 'files'
        missing creator and resolution.
    */
    func testInvalidImageFile() {
        let fileUrl = testBundle.url(forResource: "badImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testSemiInvalidImageFile() {
        let fileUrl = testBundle.url(forResource: "semiBadImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testValidImageFile() {
        let fileUrl = testBundle.url(forResource: "goodImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(result.hasResults())
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
     */
    func testInvalidVideoFile() {
        let fileUrl = testBundle.url(forResource: "badVideoFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testSemiInvalidVideoFile() {
        let fileUrl = testBundle.url(forResource: "badVideoFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testValidVideoFile() {
        let fileUrl = testBundle.url(forResource: "goodImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(result.hasResults())
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
     */
    func testInvalidDocumentFile() {
        let fileUrl = testBundle.url(forResource: "badImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testValidDocumentFile() {
        let fileUrl = testBundle.url(forResource: "goodDocumentFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(result.hasResults())
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
     */
    func testInvalidAudioFile() {
        let fileUrl = testBundle.url(forResource: "badAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testSemiInvalidAudioFile() {
        let fileUrl = testBundle.url(forResource: "semiBadAudioFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(!result.hasResults())
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
     */
    func testValidAudioFile() {
        let fileUrl = testBundle.url(forResource: "goodImageFile", withExtension: ".json", subdirectory: "jsonFiles")
        if let relPath = fileUrl?.relativePath {
            do {
                let result = try loadHandler.handle([relPath], last: MMResultSet())
                XCTAssert(result.hasResults())
            } catch(let error) {
                XCTFail("An exception was raised \(error.localizedDescription)")
            }
        } else {
            XCTFail("Failed to find file in directory")
        }
    }

}
