//
//  DownloadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class DownloadTask : TPTransferTask {
    var task: NSURLSessionDownloadTask?
    
    override init() {
        super.init()
        method = .GET
    }
   
    override func setupTask() {
        let url = NSURL(string: "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        task = session?.downloadTaskWithRequest(request)
    }
    
    public override func resume() {
        task?.resume()
    }
}