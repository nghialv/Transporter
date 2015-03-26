//
//  TPTaskGroup.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

enum RunMode {
    case Concurent
    case Serial
}

public class TPTaskGroup : TPTask {
    var mode: RunMode
    var tasks: [TPTask] = []
    var next: TPTaskGroup?
    
    public init(task: TPTask) {
        mode = .Serial
        tasks = [task]
    }
   
    public init(tasks: [TPTask]) {
        mode = .Concurent
        self.tasks = tasks
    }
    
    public init(left: TPTask, right: TPTask) {
        mode = .Serial
        tasks = [left, right]
    }
    
    public func append(task: TPTask) -> Self {
        tasks.append(task)
        return self
    }
    
    override public func resume() {
        for task in tasks {
            task.completionHandler?()
        }
        completionHandler?()
        next?.resume()
    }
}
