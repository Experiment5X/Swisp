//
//  InterpreterTests.swift
//  Swisp
//
//  Created by Adam Spindler on 2/12/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import XCTest

@testable import Swisp

class InterpreterTests: XCTestCase
{
    func testStringConcatenation()
    {
        let textExpression = "(+ (quote adam is a silly goose) (quote so is damion))"
        let expectedResult = "adam is a silly gooseso is damion"
        
        do
        {
            let interpreter = try Interpreter(lispExpression: textExpression)
            let result = try interpreter.evaluate()
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testEvaluate()
    {
        let textExpression = "(+ 5 (* 6 3))"
        let expectedResult = "23"
        
        do
        {
            let interpreter = try Interpreter(lispExpression: textExpression)
            let result = try interpreter.evaluate()
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
}