//
//  TPTaskGroup.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

// TODO
/*
- group progress
- group completion handler
*/

enum RunMode {
    case Concurent
    case Serial
}

public class TPTaskGroup : TPTask {
    var tasks: [TPTransferTask] = []
    var sessions: [NSURLSession] = []
    var mode: RunMode!
    var configured: Bool = false
    var next: TPTaskGroup?
    var curTaskIndex = 0
    private var sessionTasks: [NSURLSessionTask: TPTransferTask] = [:]
    
    public init(task: TPTransferTask) {
        super.init()
        mode = .Serial
        tasks = [task]
    }
   
    public init(tasks: [TPTransferTask]) {
        super.init()
        mode = .Concurent
        self.tasks = tasks
    }
    
    public init(left: TPTransferTask, right: TPTransferTask) {
        super.init()
        mode = .Serial
        tasks = [left, right]
    }
    
    public func append(task: TPTransferTask) -> Self {
        tasks.append(task)
        return self
    }
    
    override public func resume() {
        if !configured {
            switch mode! {
            case .Concurent:
                let session = createSession()
                sessions = [session]
                for task in tasks {
                    task.session = session
                }
            case .Serial:
                for task in tasks {
                    let session = createSession()
                    sessions.append(session)
                    task.session = session
                }
            }
            for task in tasks {
                if let st = (task as? DownloadTask)?.task {
                    sessionTasks[st] = task
                } else if let st = (task as? UploadTask)?.task {
                    sessionTasks[st] = task
                }
            }
        }
       
        if mode == .Serial {
            curTaskIndex = 0
            tasks[curTaskIndex].resume()
        } else {
            for task in tasks {
                task.resume()
            }
        }
    }
    
    private func createSession() -> NSURLSession {
        let identifier = NSUUID().UUIDString
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        configuration.HTTPMaximumConnectionsPerHost = 5
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
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
        NSLog("[Session] a session task did complete with error : \(error)")
        if let task = sessionTasks[task] {
            task.isCompleted = true
            task.completionHandler?()
        }
        var groupCompleted = false
        switch mode! {
        case .Concurent:
            groupCompleted = tasks.filter { $0.isRunning }.isEmpty
        
        case .Serial:
            curTaskIndex++
            if curTaskIndex < tasks.count {
                tasks[curTaskIndex].resume()
            } else {
                groupCompleted = true
            }
        }
        // run the completion handler of current group and call the next group resume
        if groupCompleted {
            self.completionHandler?()
            next?.resume()
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
                task.progressHandler?(completedBytes: totalBytesSent, totalBytes: totalBytesExpectedToSend)
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
            task.progressHandler?(completedBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
        }
    }
    
    // Download task completes successfully
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        NSLog("[Session] Download finished : \(location)")
    }
}