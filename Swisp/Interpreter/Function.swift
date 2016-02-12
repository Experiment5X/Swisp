//
//  Function.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

class Function
{
    var name: String = ""
    var operation: (args: [AnyObject]) -> String
    
    init(name: String, operation: (args: [AnyObject])-> String)
    {
        self.name = name
        self.operation = operation
    }
}
