//
//  TPTransferTask.swift
//  Example
//
//  Created by Le VanNghia on 3/27/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class TPTransferTask : TPTask {
    public var method: TPMethod = .GET
    var session: NSURLSession? {
        didSet {
            setupTask()
        }
    }
   
    func setupTask() {
    }
}