//
//  UserDefinedFunction.swift
//  Swisp
//
//  Created by Adam Spindler on 2/13/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

class UserDefinedFunction: Function
{
    var argNames: [String] = []
    var abstractSyntaxTreeRaw: AnyObject
    
    init(name: String, argNames: [String], abstractSyntaxTreeRaw: AnyObject)
    {
        self.argNames = argNames
        self.abstractSyntaxTreeRaw = abstractSyntaxTreeRaw
        
        super.init(name: name, operation: call)
    }
}

// call the user defined function
func call(args: [AnyObject]) throws -> AnyObject
{
    let localEnvironment = args[0] as! [String: AnyObject]
    let globalEnvironment = args[1] as! [String: AnyObject]
    let abstractSyntaxTreeRaw = args[2]
    let interpreter = Interpreter(environment: globalEnvironment)
    
    return try interpreter.evaluateRaw(abstractSyntaxTreeRaw, localEnvironment: localEnvironment)
}