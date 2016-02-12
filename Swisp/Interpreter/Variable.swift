//
//  Variable.swift
//  Swisp
//
//  Created by Adam Spindler on 2/12/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation


enum AtomicType
{
    case List
    case String
    case Number
}

class Variable: Symbol
{
    var name: String
    var value: AnyObject
    var type: AtomicType
    
    init(name: String, value: AnyObject, type: AtomicType)
    {
        self.name = name
        self.value = value
        self.type = type
    }
}