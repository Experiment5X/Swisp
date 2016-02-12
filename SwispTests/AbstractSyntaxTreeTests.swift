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
        let textExpression = "(+ 5 (* 6 3))"
        let expectedResult = [ "(", "+", "5", "(", "*", "6", "3", ")", ")"]
        
        do
        {
	        let abstractSyntaxTree = try AbstractSyntaxTree(lispExpression: textExpression)
            
	        XCTAssertEqual(abstractSyntaxTree.tokenize(textExpression), expectedResult)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testParse()
    {
        let textExpression = "(+ 5 (* 6 3))"
        let expectedResult = "[\"+\", 5.0, [\"*\", 6.0, 3.0]]"
        
        do
        {
            let abstractSyntaxTree = try AbstractSyntaxTree(lispExpression: textExpression)
            let result = abstractSyntaxTree.description
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    

}
