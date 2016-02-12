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
    private var functions: [Function] = []
    
    init(lispExpression: String) throws
    {
        try abstractSyntaxTree = AbstractSyntaxTree(lispExpression: lispExpression)
        
        // create all the library functions
        functions.append(Function(name: "+", operation: { args in
                        ((args[0] as! Double) + (args[1] as! Double)).description } ))
        functions.append(Function(name: "-", operation: { args in
                        ((args[0] as! Double) - (args[1] as! Double)).description } ))
        functions.append(Function(name: "*", operation: { args in
                        ((args[0] as! Double) * (args[1] as! Double)).description } ))
        functions.append(Function(name: "/", operation: { args in
                        ((args[0] as! Double) / (args[1] as! Double)).description } ))
    }
    
    func evaluate() throws -> String
    {
        return try evaluate(self.abstractSyntaxTree.tree)
    }
    
    private func evaluate(tree: AnyObject) throws -> String
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
                    let evaluatedArg = try ToAtomicType(evaluate(tokens[i]))
                    evaluatedArgs.append(evaluatedArg)
                }
                
                // perform the operatioj
                return function.operation(args: evaluatedArgs)
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
            return tree.description
        }
        else
        {
            return ""
        }
    }
    
    func getFunction(name: String) -> Function?
    {
        for function in functions
        {
            if function.name == name
            {
                return function
            }
        }
        return nil
    }
}