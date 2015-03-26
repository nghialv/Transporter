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
        
        let task2 = task1
        
        Transporter.push(task1)
            .progress {
                
            }
            .completed {
                
            }
            .push([task1, task2])
            .resume()
    }
}