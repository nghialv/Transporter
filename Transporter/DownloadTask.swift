//
//  DownloadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class DownloadTask : TPTask {
    public var method: TPMethod
    var task: NSURLSessionDownloadTask
    
    override init() {
        method = .GET
        task = NSURLSessionDownloadTask()
        super.init()
    }
    
    public override func resume() {
        
    }
}