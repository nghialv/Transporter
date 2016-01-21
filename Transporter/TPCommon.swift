//
//  TPCommon.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

// TODO
/*
- completionHander
    - uploading
    - downloading
    - group
*/

public enum TPMethod : String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
}

public typealias ProgressHandler = (completedBytes: Int64, totalBytes: Int64) -> ()
public typealias CompletionHandler = (tasks: [TPTransferTask]) -> ()
public typealias TransferCompletionHandler = (response: NSHTTPURLResponse?, json: AnyObject?, error: NSError?) -> ()

infix operator --> { associativity left precedence 160 }

public func --> (left: TPTransferTask, right: TPTransferTask) -> TPTaskGroup {
    return TPTaskGroup(left: left, right: right, mode: .Serialization)
}

public func --> (left: TPTaskGroup, right: TPTransferTask) -> TPTaskGroup {
    return left.append(right)
}

infix operator ||| { associativity left precedence 160 }

public func ||| (left: TPTransferTask, right: TPTransferTask) -> TPTaskGroup {
    return TPTaskGroup(left: left, right: right, mode: .Concurrency)
}

public func ||| (left: TPTaskGroup, right: TPTransferTask) -> TPTaskGroup {
    return left.append(right)
}

// http boby builder
func queryStringFromParams(params: [String: AnyObject]) -> String {
    let paramsArray = convertParamsToArray(params)
    let queryString = paramsArray.map{ "\($0)=\($1)" }.joinWithSeparator("&")
    
    return queryString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
}

func convertParamsToArray(params: [String: AnyObject]) -> [(String, AnyObject)] {
    var result = [(String, AnyObject)]()
    
    for (key, value) in params {
        if let arrayValue = value as? NSArray {
            for nestedValue in arrayValue {
                let dic = ["\(key)[]": nestedValue]
                result += convertParamsToArray(dic)
            }
        }
        else if let dicValue = value as? NSDictionary {
            for (nestedKey, nestedValue) in dicValue {
                let dic = ["\(key)[\(nestedKey)]": nestedValue]
                result += convertParamsToArray(dic)
            }
        }
        else {
            result.append(("\(key)", value))
        }
    }
    
    return result
}