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
    var tasks: [TPTransferTask] = []
    var sessions: [NSURLSession] = []
    var mode: RunMode!
    var configured: Bool = false
    var next: TPTaskGroup?
    
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
        }
        tasks.first?.resume()
    }
    
    private func createSession() -> NSURLSession {
        let identifier = NSUUID().UUIDString
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        return NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
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
    /*
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
    }
    */
    
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
        let ratio = totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown ? -1.0 : Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        NSLog("downloaded: \(ratio)")
    }
    
    // Download task completes successfully
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        NSLog("Download finished")
    }
}