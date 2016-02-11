//
//  Interpreter.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

class AbstractSyntaxTree
{
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
}