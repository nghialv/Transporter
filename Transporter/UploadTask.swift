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
    
    override init(url: String, params: [String: AnyObject]? = nil) {
        super.init(url: url, params: params)
        method = .POST
    }
    
    convenience init(url: String, data: NSData, params: [String: AnyObject]? = nil) {
        self.init(url: url, params: params)
    }
    
    convenience init(url: String, file: NSURL, params: [String: AnyObject]? = nil) {
        self.init(url: url, params: params)
        uploadDataType = .File
        self.file = file
        
        var error: NSError?
        if let attr: NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(file.path!, error: &error) {
            if error == nil {
                totalBytes = Int64(attr.fileSize())
            } else {
                NSLog("Failed to get file size")
            }
        }
    }
   
    override func setup() {
        super.setup()
        if let request = request {
            if let file = self.file {
                task = session?.uploadTaskWithRequest(request, fromFile: file)
            }
        }
    }
    
    public override func resume() {
        NSLog("[UploadTask] did resume")
        task?.resume()
    }
}