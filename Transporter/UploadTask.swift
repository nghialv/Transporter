//
//  UploadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class UploadTask : TPTransferTask {
    var task: NSURLSessionUploadTask?
    
    override init() {
        super.init()
        method = .POST
    }
    
    convenience init(data: NSData) {
        self.init()
    }
    
    convenience init(file: String) {
        self.init()
    }
   
    override func setupTask() {
        
    }
    
    public override func resume() {
        
    }
}