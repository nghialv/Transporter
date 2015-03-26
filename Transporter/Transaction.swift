//
//  Transaction.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class Transaction {
    public var progressHandler: ProgressHandler?
    public var completionHandler: CompletionHandler?
    
    public init(task: TPTask) {
        
    }
   
    public init(tasks: [TPTask]) {
        
    }
    
    public func push(task: TPTask) -> Self {
        return self
    }
    
    public func push(tasks: [TPTask]) -> Self {
        return self
    }
    
    public func progress(handler: ProgressHandler) -> Self {
        progressHandler = handler
        return self
    }
    
    public func completed(handler: CompletionHandler) -> Self {
        completionHandler = handler
        return self
    }
    
    public func resume() {
        
    }
    
    public func validate() {
        
    }
}