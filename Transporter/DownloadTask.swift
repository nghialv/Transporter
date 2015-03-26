//
//  DownloadTask.swift
//  Example
//
//  Created by Le VanNghia on 3/26/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation

public class DownloadTask : TPTask {
    override init() {
        super.init()
        method = .GET
    }
}