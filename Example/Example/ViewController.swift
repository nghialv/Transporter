//
//  ViewController.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downloadUrl1 = "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"
        let downloadUrl2 = "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"
        let downloadUrl3 = "https://s3.amazonaws.com/hayageek/downloads/SimpleBackgroundFetch.zip"
        let uploadUrl = "http://httpbin.org/post"
        
        // Downloading tasks
        let task1 = DownloadTask(url: downloadUrl1).progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task1: downloading: \(per)")
            }
            .completed {
                NSLog("task1: completed")
            }
        
        let task2 = DownloadTask(url: downloadUrl2).progress { cur, total in
            let per = Double(cur) / Double(total)
            println("task2: downloading: \(per)")
            }
            .completed {
                NSLog("task2: completed")
        }
       
        let task3 = DownloadTask(url: downloadUrl3).progress { cur, total in
            let per = Double(cur) / Double(total)
            println("task3: downloading: \(per)")
            }
            .completed {
                NSLog("task3: completed")
        }
        
        // Uploading tasks
        let tasks = (2...6).map { i -> UploadTask in
            let task = UploadTask(url: uploadUrl, data: NSData()).progress { cur, total in
                    let per = Double(cur) / Double(total)
                    println("task\(i): uploading: \(per)")
                }
                .completed {
                    NSLog("task\(i): completed")
                }
            return task
        }
        
        let task4 = tasks[0]
        let task5 = tasks[1]
       
        Transporter.push([task1, task2])
            .completed {
                NSLog("transaction1: completed")
            }
            .push(task3)
            .completed {
                NSLog("transaction2: completed")
            }
            .push([task5, task5])
            .completed {
                NSLog("transaction3: completed")
            }
            .push(tasks[2] --> tasks[3] --> tasks[4])
            .completed {
                NSLog("transaction4: completed")
            }
            .resume()
    }
}