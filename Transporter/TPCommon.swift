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