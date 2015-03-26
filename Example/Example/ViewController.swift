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
        
        let task1 = UploadTask(data: NSData())
            .progress {
                println("uploading")
            }
            .completed {
                NSLog("Completed")
            }
       
        let task2 = UploadTask(data: NSData())
            .progress {
                println("uploading")
            }
            .completed {
                NSLog("Completed")
        }
        let task3 = task1
        let task4 = task2
        
        Transporter.push(task1)
            .progress {
                
            }
            .completed {
                
            }
            .push([task2, task3])
            .completed {
                
            }
            .push(task2 --> task3 --> task4)
            .completed {
                
            }
            .resume()
    }
}