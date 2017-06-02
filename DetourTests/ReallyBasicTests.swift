//
//  ReallyBasicTests.swift
//  DetourTests
//
//  Created by Ellen Shapiro on 6/2/17.
//  Copyright © 2017 Designated Nerd Software. All rights reserved.
//

import XCTest

/// Some examples of the basics of testing
class ReallyBasicTests: XCTestCase {
    
    var number: Int!
    var string: String!
    
    //MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        self.number = 3
        self.string = "Hello testing"
    }
    
    override func tearDown() {
        self.number = nil
        self.string = nil
        super.tearDown()
    }
    
    // MARK: - Tests designed to pass

    func testTrueOrFalse() {
        XCTAssertTrue(self.number == 3)
        XCTAssertFalse(self.string == "Nope!")
    }
    
    func testNullability() {
        XCTAssertNotNil(self.string)
        self.string = nil
        XCTAssertNil(self.string)
    }
    
    func testEquality() {
        // These use the `Equatable` protocol.
        XCTAssertEqual(self.string, "Hello testing")
        XCTAssertNotEqual(self.string, "Nope!")
        
        XCTAssertEqual(self.number, 3)
        XCTAssertNotEqual(self.number, 0)
        XCTAssertNotEqual(self.number, nil)
    }
    
    func testGreaterOrLessThan() {
        // These use the `Comparable` protocol
        
        // Integer comparison: Easy!
        XCTAssertGreaterThan(self.number, 2)
        XCTAssertLessThan(self.number, 5)
        
        // String comparison is real weird.
        XCTAssertGreaterThan(self.string, "A")
        XCTAssertLessThan(self.string, "Z")
        XCTAssertGreaterThan(self.string, "Cello testing")
        XCTAssertLessThan(self.string, "Jello testing")
        
    }
    
    //MARK: - Tests designed to fail
    
    func testFailingWithAMessage() {
        XCTAssertEqual(self.number, 42, "\(self.number) is not 42")
    }
    
    func testFailingOnPurpose() {
        guard let something = Int(self.string) else {
            XCTFail("Could not convert \(self.string) to an Int")
            return
        }
        
        XCTAssertEqual(something, 3)
    }
}
