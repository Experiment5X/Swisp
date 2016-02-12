//
//  LibraryFunctions.swift
//  Swisp
//
//  Created by Adam Spindler on 2/12/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import Foundation

enum FunctionError: ErrorType
{
    case InvalidNumberOfArguments
}

func add(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 2
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if args[0] is Double && args[1] is Double
    {
        return (args[0] as! Double) + (args[1] as! Double)
    }
    else if args[0] is String && args[1] is String
    {
        return (args[0] as! String) + (args[1] as! String)
    }
    //else if args[0] is Array && args[1] is Array
    //{
	//    return (args[0] as! String) + (args[1] as! String)
    //}
    
    return nil;
}

func subtract(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 2
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if args[0] is Double && args[1] is Double
    {
        return (args[0] as! Double) - (args[1] as! Double)
    }
    
    return nil;
}

func multiply(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 2
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if args[0] is Double && args[1] is Double
    {
        return (args[0] as! Double) * (args[1] as! Double)
    }
    
    return nil;
}

func divide(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 2
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if args[0] is Double && args[1] is Double
    {
        return (args[0] as! Double) / (args[1] as! Double)
    }
    
    return nil;
}

func quote(args: [AnyObject]) throws -> AnyObject?
{
    var text = ""
    for word in args
    {
        text += word.description + " "
    }
    
    return text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}