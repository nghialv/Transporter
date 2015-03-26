//
//  UploadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class UploadTask : TPTask {
    public var method: TPMethod
    var task: NSURLSessionUploadTask
    
    override init() {
        method = .POST
        task = NSURLSessionUploadTask()
        super.init()
    }
    
    convenience init(data: NSData) {
        self.init()
    }
    
    convenience init(file: String) {
        self.init()
    }
    
    public override func resume() {
        
    }
}