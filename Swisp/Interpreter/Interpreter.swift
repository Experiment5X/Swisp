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
        let result = toString(try evaluate(abstractSyntaxTree.tree))
        
        return result
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
                // calculate the expected token count
                var expectedTokenCount = 3
                for token in tokens
                {
                    if token is String && token as! String == "'"
                    {
                        expectedTokenCount = 4
                    }
                }
                
                // check for corrent number of tokens for define call
                if tokens.count != expectedTokenCount
                {
                    throw InterpreterError.InvalidDefineArguments
                }
                
                // get the arguments for define
                let name = tokens[1] as! String
                let value = (expectedTokenCount == 3) ? try evaluate(tokens[2]) : tokens[3]
                
                // define the variable in the global environment
                try define(name, value: value, environment: &self.environment)
                
                return functionName
            }
            else if let function = getFunction(functionName)
            {
                // evaluate the arguments to the function
                var evaluatedArgs: [AnyObject] = []
                for i in 1..<tokens.count
                {
                    // check for the ' token which indicates not to evaluate the following expression
                    if tokens[i - 1] is String && tokens[i - 1] as! String == "'"
                    {
                        evaluatedArgs.append(tokens[i])
                    }
                    // don't add the ' token to the arg list
                    else if !(tokens[i] is String && tokens[i] as! String == "'")
                    {
		                evaluatedArgs.append(try evaluate(tokens[i]))
                    }
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
    
    private func toString(value: AnyObject) -> String
    {
        if value is String || value is Double
        {
            return value.description
        }
        else if value is [AnyObject]
        {
            var txt = "["
            let values: [AnyObject] = value as! [AnyObject]
            
            for val in values
            {
                if val === values.last
                {
                    txt += toString(val)
                }
                else
                {
                    txt += toString(val) + ", "
                }
            }
            
            txt += "]"
            return txt
        }
        else
        {
            return "Unknown Type"
        }
    }
}