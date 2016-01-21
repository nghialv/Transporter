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
    var data: NSData?
    var stream: NSInputStream?
    
    public override init(url: String, params: [String: AnyObject]? = nil) {
        super.init(url: url, params: params)
        method = .POST
    }
    
    public convenience init(url: String, data: NSData) {
        self.init(url: url)
        uploadDataType = .Data
        self.data = data
        totalBytes = Int64(data.length)
    }
    
    public convenience init(url: String, file: NSURL) {
        self.init(url: url)
        uploadDataType = .File
        self.file = file
        
        var error: NSError?
        do {
            let attr: NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(file.path!)
            if error == nil {
                totalBytes = Int64(attr.fileSize())
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    public convenience init(url: String, stream: NSInputStream) {
        self.init(url: url)
        uploadDataType = .Stream
        self.stream = stream
    }
    
    override func setup() {
        super.setup()
        if let request = request {
            switch uploadDataType {
            case .File:
                if let file = self.file {
                    task = session?.uploadTaskWithRequest(request, fromFile: file)
                }
            case .Data:
                task = session?.uploadTaskWithRequest(request, fromData: data!)
            case .Stream:
                task = session?.uploadTaskWithStreamedRequest(request)
                break
            }
        }
    }
    
    public override func resume() {
        NSLog("[UploadTask] did resume")
        task?.resume()
    }
}