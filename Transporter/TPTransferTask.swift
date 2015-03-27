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
    public var HTTPShouldUsePipelining = false
    public var HTTPShouldHandleCookies = true
    public var allowsCellularAccess = true
    public var params: [String: AnyObject]?
    public var headers: [String: String]?
    
    var url: String
    var request: NSMutableURLRequest?
    var totalBytes: Int64 = 0
    var session: NSURLSession?
    
    init(url: String, params: [String: AnyObject]? = nil) {
        self.url = url
        self.params = params
        super.init()
    }
   
    func setup() {
        let requestUrl = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = method.rawValue
        request.HTTPShouldUsePipelining = HTTPShouldUsePipelining
        request.HTTPShouldHandleCookies = HTTPShouldHandleCookies
        request.allowsCellularAccess = allowsCellularAccess
        
        // append header
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        // append http body
        if let params = params {
            
        }
        
        self.request = request
    }
}