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
    case InvalidDefineArguments
    case NullFunctionReturnValue
    case VariableAlreadyDefined
}

class Interpreter
{
    private var environment: [String: AnyObject] = [:]
    
    init() throws
    {
        // add all the library functions
        environment["+"] = Function(name: "+", operation: add)
        environment["-"] = Function(name: "-", operation: subtract)
        environment["*"] = Function(name: "*", operation: multiply)
        environment["/"] = Function(name: "/", operation: divide)
        environment["quote"] = Function(name: "quote", operation: quote)
    }
    
    func evaluate(lispExpression: String) throws -> String
    {
        let abstractSyntaxTree = try AbstractSyntaxTree(lispExpression: lispExpression)
        return try evaluate(abstractSyntaxTree.tree).description
    }
    
    private func evaluate(tree: AnyObject) throws -> AnyObject
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
            if functionName == "define"
            {
                if tokens.count != 3
                {
                    throw InterpreterError.InvalidDefineArguments
                }
                
                let name = tokens[1] as! String
                let value = try evaluate(tokens[2])
                
                try define(name, value: value, environment: &self.environment)
                
                return functionName
            }
            else if let function = getFunction(functionName)
            {
                // evaluate the arguments to the function
                var evaluatedArgs: [AnyObject] = []
                for i in 1..<tokens.count
                {
	                evaluatedArgs.append(try evaluate(tokens[i]))
                }
                
                // perform the operation
                if let result = try function.operation(args: evaluatedArgs)
                {
                    return result
                }
                else
                {
                    throw InterpreterError.NullFunctionReturnValue
                }
            }
            else
            {
                throw InterpreterError.UndefinedFunction
            }
        }
        else if tree is String
        {
            let str = tree as! String
            
            // check to see if it's a variable
            if let variable = self.environment[str]
            {
                if !(variable is Function)
                {
	                return variable
                }
            }
            
            return str
        }
        else if tree is Double
        {
            return tree
        }
        
        return ""
    }
    
    func getFunction(name: String) -> Function?
    {
        for obj in environment
        {
            if obj.1 is Function && obj.0 == name
            {
                return obj.1 as! Function
            }
        }
        return nil
    }
    
    private func define(name: String, value: AnyObject, inout environment: [String: AnyObject]) throws
    {
        if let _ = environment[name]
        {
            throw InterpreterError.VariableAlreadyDefined
        }
        else
        {
            environment[name] = value
        }
    }
}