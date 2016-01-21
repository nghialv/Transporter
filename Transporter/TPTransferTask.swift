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
    public var completionHandler: TransferCompletionHandler?
    
    var url: String
    var request: NSMutableURLRequest?
    var totalBytes: Int64 = 0
    var session: NSURLSession?
    var responseData: NSData?
    var jsonData: AnyObject? {
        if let reponseData = responseData {
            return try? NSJSONSerialization.JSONObjectWithData(reponseData, options: .AllowFragments)
        }
        return nil
    }
    var error: NSError?
    var failed: Bool {
        return error != nil
    }
    
    public init(url: String, params: [String: AnyObject]? = nil) {
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
            if method == .GET {
                let query = queryStringFromParams(params)
                let newUrl = url.stringByAppendingString("?\(query)")
                request.URL = NSURL(string: newUrl)
            }
        }
        
        self.request = request
    }
    
    public func completed(handler: TransferCompletionHandler) -> Self {
        completionHandler = handler
        return self
    }
}