//
//  Interpreter.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//
//  A lot of the code was derived from this tutorial http://norvig.com/lispy.html

import Foundation
import UIKit

enum AbstractSyntaxTreeError: ErrorType
{
    case UnexpectedEndOfInput
    case UnexpectedClosedParenthesis
    case UnknownPrimitiveType
}

func ToAtomicType(token: String) -> AnyObject
{
    if let number = Double(token)
    {
        return number
    }
    else if token.characters.first == "\"" && token.characters.last == "\""
    {
        let cleanedStr = token.stringByReplacingOccurrencesOfString("\"", withString: "")
        return cleanedStr
    }
    
    return token
}

class AbstractSyntaxTree: CustomStringConvertible
{
    var tree: AnyObject = []
    
    init(lispExpression: String) throws
    {
        if lispExpression.characters.count != 0
        {
	        try tree = parse(lispExpression)
        }
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
            return ToAtomicType(token)
        }
    }
    
    var description: String
    {
        return AbstractSyntaxTree.ToString(tree)
    }
    
    class func ToString(object: AnyObject) -> String
    {
        var str = ""
        if object is [AnyObject]
        {
            str = "["
            for obj in object as! [AnyObject]
            {
                str += ToString(obj) + ", "
            }
            
            // trim off the extra ", "
            let lastCommaIndex = str.startIndex.advancedBy(str.characters.count - 2)
            str = str.substringToIndex(lastCommaIndex)
            
            str += "]"
        }
        else if object is String
        {
            str = "\"" + (object as! String) + "\""
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
    
    class func ToAttributedString(object: AnyObject) -> NSAttributedString
    {
        var toReturn: NSMutableAttributedString = NSMutableAttributedString()
        if object is [AnyObject]
        {
            // add opening parenthesis
            toReturn.appendAttributedString(NSAttributedString(string: "[", attributes: [NSForegroundColorAttributeName: UIColor.redColor()]))
           
            for obj in object as! [AnyObject]
            {
                toReturn.appendAttributedString(ToAttributedString(obj))
                toReturn.appendAttributedString(NSAttributedString(string: ", "))
            }
            
            // remove the extra ", "
            toReturn = NSMutableAttributedString(attributedString: toReturn.attributedSubstringFromRange(NSMakeRange(0, toReturn.length - 2)))
            
            // add closing parenthesis
            toReturn.appendAttributedString(NSAttributedString(string: "]", attributes: [NSForegroundColorAttributeName: UIColor.redColor()]))
        }
        else if object is String
        {
            let quotedString = "\"" + (object as! String) + "\""
            toReturn.appendAttributedString(NSAttributedString(string: quotedString, attributes: [NSForegroundColorAttributeName: UIColor.magentaColor()]))
        }
        else if object is Double
        {
            toReturn.appendAttributedString(NSAttributedString(string: (object as! Double).description, attributes: [NSForegroundColorAttributeName: UIColor.blueColor()]))
        }
        
        return toReturn
    }
}