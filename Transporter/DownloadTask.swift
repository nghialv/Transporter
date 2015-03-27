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
    
    override init(url: String) {
        super.init(url: url)
        method = .GET
    }
   
    override func setupTask() {
        let requestUrl = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = method.rawValue
        task = session?.downloadTaskWithRequest(request)
    }
    
    public override func resume() {
        task?.resume()
    }
}