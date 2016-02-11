//
//  InterpreterTests.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import XCTest
@testable import Swisp

class AbstractSyntaxTreeTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTokenize()
    {
        let abstractSyntaxTree = AbstractSyntaxTree()
        
        let textExpression = "(+ 5 (* 6 3))"
        let expectedResult = [ "(", "+", "5", "(", "*", "6", "3", ")", ")"]
        
        XCTAssertEqual(abstractSyntaxTree.tokenize(textExpression), expectedResult)
    }
}
