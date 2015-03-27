//
//  TPCommon.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public enum TPMethod : String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
}

public typealias ProgressHandler = (completedBytes: Int64, totalBytes: Int64) -> ()
public typealias CompletionHandler = () -> ()

infix operator --> { associativity left precedence 160 }

func --> (left: TPTransferTask, right: TPTransferTask) -> TPTaskGroup {
    return TPTaskGroup(left: left, right: right)
}

func --> (left: TPTaskGroup, right: TPTransferTask) -> TPTaskGroup {
    return left.append(right)
}