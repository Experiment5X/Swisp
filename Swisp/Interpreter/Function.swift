//
//  Function.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

class Function: Symbol
{
    var name: String = ""
    var operation: (args: [AnyObject]) throws -> AnyObject?
    
    init(name: String, operation: (args: [AnyObject]) throws -> AnyObject?)
    {
        self.name = name
        self.operation = operation
    }
}
