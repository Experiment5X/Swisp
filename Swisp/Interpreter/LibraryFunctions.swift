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
    case InvalidArgumentType
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
    else if args[0] is [AnyObject] && args[1] is [AnyObject]
    {
        var list1 = args[0] as! [AnyObject]
        let list2 = args[1] as! [AnyObject]
        
        list1.appendContentsOf(list2)
        return list1
    }
    
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

func car(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 1
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if let list = args[0] as? [AnyObject]
    {
        return list.first
    }
    else
    {
        throw FunctionError.InvalidArgumentType
    }
}

func cdr(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 1
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if var list = args[0] as? [AnyObject]
    {
        list.removeFirst()
        return list
    }
    else
    {
        throw FunctionError.InvalidArgumentType
    }
}

func cons(args: [AnyObject]) throws -> AnyObject?
{
    if args.count == 0
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    return args
}

func equals(args: [AnyObject]) throws -> AnyObject?
{
    if args.count != 2
    {
        throw FunctionError.InvalidNumberOfArguments
    }
    
    if args[0] is Double && args[1] is Double
    {
        let num1 = args[0] as! Double
        let num2 = args[1] as! Double
        
        return (num1 == num2) ? 1.0 : 0.0;
    }
    else if args[0] is String && args[1] is String
    {
        let str1 = args[0] as! String
        let str2 = args[1] as! String
        
        return (str1 == str2) ? 1.0 : 0.0;
    }
    
    return 0.0
}