//
//  MediaLibUnitTests.swift
//  MediaLibUnitTests
//
//  Created by Harrison Ellerm on 9/08/18.
//  Copyright © 2018 Paul Crane. All rights reserved.
//

import XCTest

@testable import MediaLibraryManager

class MediaLibUnitTests: XCTestCase {
    
    let json = """
                [{"fullpath":"/somepath/bad1.json","type":"image","metadata":{"taken_on":"today","name":"bad_image"}},{"fullpath":"/somepath/bad1.json","type":"image","metadata":{"taken_on":"today","name":"bad_image"}}]
                """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let lc = LoadCommandHandler()
        do {
            let result = try lc.handle([json], last: MMResultSet())
            print(result.hasResults())
        } catch {
            print("Exception was raised")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
