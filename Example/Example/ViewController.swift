//
//  ViewController.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func didPressedStartButton(sender: AnyObject) {
        let downloadUrl1 = "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"
        let downloadUrl2 = "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf"
        let downloadUrl3 = "https://s3.amazonaws.com/hayageek/downloads/SimpleBackgroundFetch.zip"
        let uploadUrl = "http://httpbin.org/post"
        
        // Downloading tasks
        let task1 = DownloadTask(url: downloadUrl1)
            .progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task1: downloading: \(per)")
            }
            .completed {
                println("task1: completed")
            }
        
        let task2 = DownloadTask(url: downloadUrl2)
            .progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task2: downloading: \(per)")
            }
            .completed {
                println("task2: completed")
            }
       
        let task3 = DownloadTask(url: downloadUrl3)
            .progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task3: downloading: \(per)")
            }
            .completed {
                println("task3: completed")
            }
        
        // Uploading tasks
        let path = NSBundle.mainBundle().pathForResource("zip_file", ofType: "zip")
        let fileUrl = NSURL(fileURLWithPath: path!)!
        let task4 = UploadTask(url: uploadUrl, file: fileUrl)
            .progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task4: uploading: \(per)")
            }
            .completed {
                println("task4: completed")
            }
        
        let path2 = NSBundle.mainBundle().pathForResource("zip_file2", ofType: "zip")
        let fileUrl2 = NSURL(fileURLWithPath: path!)!
        let task5 = UploadTask(url: uploadUrl, file: fileUrl2)
            .progress { cur, total in
                let per = Double(cur) / Double(total)
                println("task5: uploading: \(per)")
            }
            .completed {
                println("task5: completed")
            }
        
        let tasks = (6...8).map { i -> UploadTask in
            let task = UploadTask(url: uploadUrl, file: fileUrl)
                .progress { cur, total in
                    let per = Double(cur) / Double(total)
                    println("task\(i): uploading: \(per)")
                }
                .completed {
                    println("task\(i): completed")
                }
            return task
        }
       
        /*
        Transporter.push([task1, task2])
            .completed {
                println("transaction1: completed")
            }
            .push(task3)
            .completed {
                println("transaction2: completed")
            }
            .resume()
        
        Transporter.push(task4)
            .completed {
                println("transaction3: completed")
            }
            .resume()
        */
        
        Transporter.push(task1 <--> task2)
            .progress { cur, total in
                let ratio = Double(cur) / Double(total)
                println("transaction4: \(ratio)")
            }
            .completed {
                println("transaction4: completed")
            }
            .resume()
        
        /*
            .push(task1)
            .completed {
                println("transaction5: completed")
            }
            .resume()
            .push(tasks[2] --> tasks[3] --> tasks[4])
            .completed {
                println("transaction5: completed")
            }
            .resume()
            */
    }
}