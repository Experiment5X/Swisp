//
//  Interpreter.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//
//  A lot of the code was derived from this tutorial http://norvig.com/lispy.html

import Foundation

enum AbstractSyntaxTreeError: ErrorType
{
    case UnexpectedEndOfInput
    case UnexpectedClosedParenthesis
}

class AbstractSyntaxTree: CustomStringConvertible
{
    private var tree: AnyObject = []
    
    init(lispExpression: String) throws
    {
        try tree = parse(lispExpression)
    }
    
    func tokenize(textExpression: String) -> [String]
    {
        // add spaces around all the parentheses
        var spacedParens = textExpression.stringByReplacingOccurrencesOfString("(", withString: " ( ")
        spacedParens = spacedParens.stringByReplacingOccurrencesOfString(")", withString: " ) ")
        
        // split the string on all the spaces
        let tokens = spacedParens.componentsSeparatedByString(" ")
        
        // remove empty strings from the list of tokens
        var realTokens: [String] = []
        for token in tokens
        {
            if !token.isEmpty
            {
                realTokens.append(token)
            }
        }
        
        return realTokens
    }
    
    func parse(lispExpression: String) throws -> AnyObject
    {
        var tokens = tokenize(lispExpression)
        return try buildTokenTree(&tokens)
    }
    
    func buildTokenTree(inout tokens: [String]) throws -> AnyObject
    {
        if tokens.count == 0
        {
            throw AbstractSyntaxTreeError.UnexpectedEndOfInput
        }
        
        // (+ 5 (* 4 3))
        
        let token = tokens.removeFirst()
        if token == "("
        {
            // build a token tree
            var tokenTree: [AnyObject] = []
            while tokens[0] != ")"
            {
                try tokenTree.append(buildTokenTree(&tokens))
            }
            
            tokens.removeFirst()
            return tokenTree
        }
        else if token == ")"
        {
            throw AbstractSyntaxTreeError.UnexpectedClosedParenthesis
        }
        else
        {
            return atomicType(token)
        }
    }
    
    func atomicType(token: String) -> AnyObject
    {
        if let number = Double(token)
        {
            return number
        }
        return token as String
    }
    
    var description: String
    {
        return convertToString(tree)
    }
    
    func convertToString(object: AnyObject) -> String
    {
        var str = ""
        if object is [AnyObject]
        {
            str = "["
            for obj in object as! [AnyObject]
            {
                str += convertToString(obj) + ", "
            }
            
            // trim off the extra ", "
            let lastCommaIndex = str.startIndex.advancedBy(str.characters.count - 2)
            str = str.substringToIndex(lastCommaIndex)
            
            str += "]"
        }
        else if object is String
        {
            str = object as! String
        }
        else if object is Double
        {
            str = String(object as! Double)
        }
        else
        {
            str = "Unknown Object"
        }
        
        return str
    }
}