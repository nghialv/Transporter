//
//  Transaction.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class Transaction {
    private var firstTaskGroup: TPTaskGroup
    var currentTaskGroup: TPTaskGroup?
    
    public init(task: TPTask) {
        firstTaskGroup = TPTaskGroup(task: task)
        currentTaskGroup = firstTaskGroup
    }
   
    public init(tasks: [TPTask]) {
        firstTaskGroup = TPTaskGroup(tasks: tasks)
        currentTaskGroup = firstTaskGroup
    }
    
    public init(taskGroup: TPTaskGroup) {
        firstTaskGroup = taskGroup
        currentTaskGroup = firstTaskGroup
    }
    
    public func push(task: TPTask) -> Self {
        let group = TPTaskGroup(task: task)
        currentTaskGroup?.next = group
        currentTaskGroup = group
        return self
    }
    
    public func push(tasks: [TPTask]) -> Self {
        let group = TPTaskGroup(tasks: tasks)
        currentTaskGroup?.next = group
        currentTaskGroup = group
        return self
    }
   
    public func push(taskGroup: TPTaskGroup) -> Self {
        currentTaskGroup?.next = taskGroup
        currentTaskGroup = taskGroup
        return self
    }
}

extension Transaction {
    public func progress(handler: ProgressHandler) -> Self {
        currentTaskGroup?.progressHandler = handler
        return self
    }
    
    public func completed(handler: CompletionHandler) -> Self {
        currentTaskGroup?.completionHandler = handler
        return self
    }
    
    public func resume() {
        firstTaskGroup.resume()
    }
    
    public func validate() {
        
    }
}