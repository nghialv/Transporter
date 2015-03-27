//
//  TPTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

// TODO
/*
- resume
- suspend
- cancel
*/

public class TPTask : NSObject {
    public var retryCount: UInt = 1
    public var progressHandler: ProgressHandler?
    internal(set) public var isCompleted: Bool = false
    public var isRunning : Bool {
        return !isCompleted
    }
    
    public func progress(handler: ProgressHandler) -> Self {
        progressHandler = handler
        return self
    }
    
    public func resume() {
        
    }
    
    public func suspend() {
        
    }
    
    public func cancel() {
        
    }
}