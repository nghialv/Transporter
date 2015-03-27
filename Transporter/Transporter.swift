//
//  Transporter.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public struct Transporter {
    private static var backgroundEventHandlers: [() -> ()] = []
    
    public static func push(task: TPTransferTask) -> Transaction {
        let transaction = Transaction(task: task)
        return transaction
    }
    
    public static func push(tasks: [TPTransferTask]) -> Transaction {
        let transaction = Transaction(tasks: tasks)
        return transaction
    }
    
    public static func push(taskGroup: TPTaskGroup) -> Transaction {
        let transaction = Transaction(taskGroup: taskGroup)
        return transaction
    }
}

public extension Transporter {
    static func handleEventsForBackgroundURLSection(identifier: String, completionHandler: () -> ()) {
        
    }
}
