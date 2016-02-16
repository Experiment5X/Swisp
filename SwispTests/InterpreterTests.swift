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
            let interpreter = Interpreter()
            let result = try interpreter.evaluate(textExpression)
            
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
            let interpreter = Interpreter()
            let result = try interpreter.evaluate(textExpression)
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testVariables()
    {
        let expectedResult = "30"
        
        do
        {
            let interpreter = Interpreter()
            try interpreter.evaluate("(define a 5)")
            
            let result = try interpreter.evaluate("(* (+ a a) 3)")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testLists()
    {
        let expectedResult = "[1, 2, 3, 4, 5]"
       
        do
        {
            let interpreter = Interpreter()
            let result = try interpreter.evaluate("(+ '(1 2) '(3 4 5))")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testCar()
    {
        let expectedResult = "1"
       
        do
        {
            let interpreter = Interpreter()
            let result = try interpreter.evaluate("(car '(1 2 3 4 5))")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testCdr()
    {
        let expectedResult = "[2, 3, 4, 5]"
       
        do
        {
            let interpreter = Interpreter()
            let result = try interpreter.evaluate("(cdr '(1 2 3 4 5))")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testCons()
    {
        let expectedResult = "[1, 2, 3, 4, 5]"
       
        do
        {
            let interpreter = Interpreter()
            let result = try interpreter.evaluate("(cons 1 2 3 4 5)")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testUserDefinedFunction()
    {
        let expectedResult = "30"
       
        do
        {
            let interpreter = Interpreter()
            try interpreter.evaluate("(lambda yo (a b) (* a b))")
            let result = try interpreter.evaluate("(yo 5 6)")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testIfEquals()
    {
        let expectedResult = "5"
       
        do
        {
            let interpreter = Interpreter()
            let result = try interpreter.evaluate("(if (= 4 4) (+ 3 2) (* 2 9))")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
    
    func testRecrusiveFunction()
    {
        let expectedResult = "24"
       
        do
        {
            let interpreter = Interpreter()
            try interpreter.evaluate("(lambda factorial (num) (if (= num 0) 1 (* (factorial (- num 1)) num)))")
            let result = try interpreter.evaluate("(factorial 4)")
            
            XCTAssertEqual(expectedResult, result)
        }
        catch
        {
            XCTAssert(false)
        }
    }
}