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
    
    override init(url: String) {
        super.init(url: url)
        method = .POST
    }
    
    convenience init(url: String, data: NSData) {
        self.init(url: url)
    }
    
    convenience init(url: String, file: String) {
        self.init(url: url)
    }
   
    override func setupTask() {
        
    }
    
    public override func resume() {
        
    }
}