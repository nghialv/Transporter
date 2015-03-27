//
//  TPTransferTask.swift
//  Example
//
//  Created by Le VanNghia on 3/27/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

// TODO
/*
- header configuration
- parameter 
- resume
- suspend
- cancel
*/

public class TPTransferTask : TPTask {
    public var method: TPMethod = .GET
    var url: String
    var totalBytes: Int64 = 0
    var session: NSURLSession? {
        didSet {
            setupTask()
        }
    }
    
    init(url: String) {
        self.url = url
        super.init()
    }
   
    func setupTask() {
    }
}