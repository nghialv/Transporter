//
//  UploadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public enum UploadDataType {
    case Data
    case File
    case Stream
}

public class UploadTask : TPTransferTask {
    var task: NSURLSessionUploadTask?
    var uploadDataType: UploadDataType = .File
    var file: NSURL?
    
    override init(url: String) {
        super.init(url: url)
        method = .POST
    }
    
    convenience init(url: String, data: NSData) {
        self.init(url: url)
    }
    
    convenience init(url: String, file: NSURL) {
        self.init(url: url)
        uploadDataType = .File
        self.file = file
    }
   
    override func setupTask() {
        let requestUrl = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = method.rawValue
        if let file = self.file {
            task = session?.uploadTaskWithRequest(request, fromFile: file)
        }
    }
    
    public override func resume() {
        NSLog("[UploadTask] did resume")
        task?.resume()
    }
}