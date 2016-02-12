//
//  Interpreter.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

enum InterpreterError: ErrorType
{
    case EmptyExpression
    case InvalidFunctionType
    case UndefinedFunction
}

class Interpreter
{
    private var abstractSyntaxTree: AbstractSyntaxTree = try! AbstractSyntaxTree(lispExpression: "")
    private var environment: [Symbol] = []
    
    init(lispExpression: String) throws
    {
        try abstractSyntaxTree = AbstractSyntaxTree(lispExpression: lispExpression)
        
        // add all the library functions
        environment.append(Function(name: "+", operation: add))
        environment.append(Function(name: "-", operation: subtract))
        environment.append(Function(name: "*", operation: multiply))
        environment.append(Function(name: "/", operation: divide))
        environment.append(Function(name: "quote", operation: quote))
    }
    
    func evaluate() throws -> String
    {
        if let evaluated = try evaluate(self.abstractSyntaxTree.tree)
        {
            return evaluated.description
        }
        else
        {
            return "An error occurred";
        }
    }
    
    private func evaluate(tree: AnyObject) throws -> AnyObject?
    {
        if tree is [AnyObject]
        {
            let tokens = tree as! [AnyObject]
            if tokens.count == 0
            {
                throw InterpreterError.EmptyExpression
            }
            
            if !(tokens[0] is String)
            {
                throw InterpreterError.InvalidFunctionType
            }
            
            let functionName = tokens[0] as! String
            if let function = getFunction(functionName)
            {
                // evaluate the arguments to the function
                var evaluatedArgs: [AnyObject] = []
                for i in 1..<tokens.count
                {
                    if let evaluatedArg = try evaluate(tokens[i])
                    {
	                    evaluatedArgs.append(evaluatedArg)
                    }
                }
                
                // perform the operation
                return try function.operation(args: evaluatedArgs)
            }
            else
            {
                throw InterpreterError.UndefinedFunction
            }
        }
        else if tree is String
        {
            return tree as! String
        }
        else if tree is Double
        {
            return tree
        }
        else
        {
            return ""
        }
    }
    
    func getFunction(name: String) -> Function?
    {
        for symbol in environment
        {
            if symbol is Function && symbol.name == name
            {
                return symbol as! Function
            }
        }
        return nil
    }
    
    private func define(args: [AnyObject]) -> String
    {
        return ""
    }
}