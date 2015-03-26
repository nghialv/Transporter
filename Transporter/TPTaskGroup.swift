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
    var mode: RunMode = .Concurent
    var tasks: [TPTask] = []
    var next: TPTaskGroup?
    let identifier = NSUUID().UUIDString
    let section: NSURLSession!
    let configuration: NSURLSessionConfiguration!
   
    override init() {
        super.init()
        // TODO: check os version
        self.configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        section = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    convenience public init(task: TPTask) {
        self.init()
        mode = .Serial
        tasks = [task]
    }
   
    convenience public init(tasks: [TPTask]) {
        self.init()
        mode = .Concurent
        self.tasks = tasks
    }
    
    convenience public init(left: TPTask, right: TPTask) {
        self.init()
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

extension TPTaskGroup : NSURLSessionDelegate {
    // All tasks enqueued have been delivered
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
    }
}

extension TPTaskGroup : NSURLSessionTaskDelegate {
    // When any task completes
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    }
    
    // Requests credentials from the delegate in response to an authentication request from the remote server
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let uploadTask = task as? NSURLSessionUploadTask {
            
        }
    }
}

extension TPTaskGroup : NSURLSessionDownloadDelegate {
    //  The download task has resumed downloading
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
    
    // Periodically informs the delegate about the download’s progress
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }
    
    // Download task completes successfully
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
    }
}