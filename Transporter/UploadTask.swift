//
//  UploadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class UploadTask : TPTask {

    init(data: NSData) {
        super.init()
        method = .POST
    }
    
    init(file: String) {
        super.init()
        method = .POST
    }
}