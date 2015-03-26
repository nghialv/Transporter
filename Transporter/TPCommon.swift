//
//  TPCommon.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public enum TPMethod {
    case GET
    case POST
    case PUT
}

public typealias ProgressHandler = () -> ()
public typealias CompletionHandler = () -> ()

infix operator --> { associativity left precedence 160 }

func --> (left: TPTask, right: TPTask) -> TPTaskGroup {
    return TPTaskGroup()
}

func --> (left: TPTaskGroup, right: TPTask) -> TPTaskGroup {
    return left
}