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
       
        let task1 = DownloadTask()
            .progress {
                println("task1: uploading")
            }
            .completed {
                NSLog("task1: completed")
        }
        
        let tasks = (2...6).map { i -> UploadTask in
            let task = UploadTask(data: NSData())
                .progress {
                    NSLog("task\(i): uploading")
                }
                .completed {
                    NSLog("task\(i): completed")
                }
            return task
        }
        
        let task2 = tasks[0]
        let task3 = tasks[1]
        
        Transporter.push(task1)
            .completed {
                NSLog("transaction1: completed")
            }
            .push([task2, task3])
            .completed {
                NSLog("transaction2: completed")
            }
            .push(tasks[2] --> tasks[3] --> tasks[4])
            .completed {
                NSLog("transaction3: completed")
            }
            .resume()
    }
}