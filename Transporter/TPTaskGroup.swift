//
//  TPTaskGroup.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation
import UIKit

// TODO
/*
- group progress
- group completion handler
*/

public enum RunMode {
    case Concurrency
    case Serialization
}

public class TPTaskGroup : TPTask {
    public var completionHandler: CompletionHandler?
    
    var tasks: [TPTransferTask] = []
    var sessions: [NSURLSession] = []
    var mode: RunMode!
    var configured: Bool = false
    var next: TPTaskGroup?
    var curTaskIndex = 0
    var totalBytes: Int64 = 0
    var completedBytes: Int64 = 0
    
    private var sessionTasks: [NSURLSessionTask: TPTransferTask] = [:]
    
    public init(task: TPTransferTask) {
        super.init()
        mode = .Serialization
        tasks = [task]
    }
   
    public init(tasks: [TPTransferTask]) {
        super.init()
        mode = .Concurrency
        self.tasks = tasks
    }
    
    public init(left: TPTransferTask, right: TPTransferTask, mode: RunMode) {
        super.init()
        self.mode = mode
        tasks = [left, right]
    }
    
    public func append(task: TPTransferTask) -> Self {
        tasks.append(task)
        return self
    }
    
    override public func resume() {
        if !configured {
            switch mode! {
            case .Concurrency:
                let session = createSession()
                sessions = [session]
                for task in tasks {
                    task.session = session
                }
            case .Serialization:
                for task in tasks {
                    let session = createSession()
                    sessions.append(session)
                    task.session = session
                }
            }
            
            for task in tasks {
                task.setup()
                if let st = (task as? DownloadTask)?.task {
                    sessionTasks[st] = task
                } else if let st = (task as? UploadTask)?.task {
                    sessionTasks[st] = task
                }
            }
            totalBytes = tasks.reduce(0) { $0 + $1.totalBytes }
        }
       
        if mode == .Serialization {
            curTaskIndex = 0
            tasks[curTaskIndex].resume()
        } else {
            for task in tasks {
                task.resume()
            }
        }
    }
   
    public func completed(handler: CompletionHandler) -> Self {
        completionHandler = handler
        return self
    }
    
    private func createSession() -> NSURLSession {
        let identifier = NSUUID().UUIDString
       
        var configuration: NSURLSessionConfiguration!
        
        if UIDevice.systemVersionGreaterThanOrEqualTo("8.0") {
            configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        } else {
            configuration = NSURLSessionConfiguration.backgroundSessionConfiguration(identifier)
        }
        
        configuration.HTTPMaximumConnectionsPerHost = Transporter.HTTPMaximumconnectionsPerHost
        configuration.timeoutIntervalForRequest = Transporter.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = Transporter.timeoutIntervalForResource
        configuration.HTTPAdditionalHeaders = Transporter.headers
        
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }
}


extension TPTaskGroup : NSURLSessionDelegate {
    // All tasks enqueued have been delivered
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        // check if all tasks have been completed
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            if dataTasks.isEmpty && uploadTasks.isEmpty && downloadTasks.isEmpty {
                Transporter.sessionDidFinishEventsForBackgroundURLSession(session)
            }
        }
    }
}


extension TPTaskGroup : NSURLSessionDataDelegate {
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if let task = sessionTasks[dataTask] {
            task.responseData = data
        }
    }
}

extension TPTaskGroup : NSURLSessionTaskDelegate {
    // When any task completes
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        NSLog("[Session] a session task did complete with error : \(error)")
        
        let curTask: TPTransferTask! = sessionTasks[task]
        if curTask == nil {
            return
        }
        curTask.error = error
        curTask.isCompleted = true
            
        let httpResponse = task.response as? NSHTTPURLResponse
        let json: AnyObject? = curTask.jsonData
        curTask.completionHandler?(response: httpResponse, json: json, error: error)
        
        // find the next task to resume
        switch mode! {
        case .Concurrency:
            let groupCompleted = tasks.filter { $0.isRunning }.isEmpty
            if groupCompleted {
                self.completionHandler?(tasks: tasks)
                next?.resume()
            }
        
        case .Serialization:
            curTaskIndex++
            if curTaskIndex < tasks.count && !curTask.failed {
                tasks[curTaskIndex].resume()
            } else {
                self.completionHandler?(tasks: tasks)
                next?.resume()
            }
        }
    }
    
    // Requests credentials from the delegate in response to an authentication request from the remote server
    /*
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
    }
    */
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let uploadTask = task as? NSURLSessionUploadTask {
            if let task = sessionTasks[uploadTask] {
                completedBytes += bytesSent
                task.progressHandler?(completedBytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
                self.progressHandler?(completedBytes: completedBytes, totalBytes: totalBytes)
            }
        }
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        if let uploadTask = task as? NSURLSessionUploadTask {
            if let task = sessionTasks[uploadTask] as? UploadTask {
                completionHandler(task.stream!)
            }
        }
    }
}


extension TPTaskGroup : NSURLSessionDownloadDelegate {
    //  The download task has resumed downloading
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
    
    // Periodically informs the delegate about the download’s progress
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let task = sessionTasks[downloadTask] {
            completedBytes += bytesWritten
            task.progressHandler?(completedBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }
    
    // Download task completes successfully
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        NSLog("[Session] Download finished : \(location)")
        if let task = sessionTasks[downloadTask] as? DownloadTask {
            do {
                try NSFileManager.defaultManager().moveItemAtURL(location, toURL: task.destination)
            } catch let error as NSError {
                task.movingError = error
            }
        }
    }
}