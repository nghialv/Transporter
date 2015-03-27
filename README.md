<p align="center">
<img style="-webkit-user-select: none;" src="https://dl.dropboxusercontent.com/u/8556646/transporter.png" width="700" height="218">
</p>

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/nghialv/Transporter.svg?style=flat
)](https://github.com/nghialv/Transporter/issues?state=open)




Features
-----

- multiple files (parallel, serial)
- progress
- retry
- timeout
- header settings
- background
- LlamaKit (https://github.com/LlamaKit/LlamaKit)


**Quick example**

``` swift
let path = NSBundle.mainBundle().pathForResource("bigfile", ofType: "zip")
let fileUrl = NSURL(fileURLWithPath: path!)!

let task = UploadTask(url: "http://server.com", file: fileUrl)
	.progress { sent, total in
		let per = Double(sent) / Double(total)
		println("uploading: \(per)")
	}
	.completed { response, _, error in
		println("completed")
	}

 
 Transporter.add(task1 --> task2 --> task3)
            .progress { bytes, total in
                let ratio = Double(bytes) / Double(total)
                println("serial tasks: \(ratio)")
            }
            .completed {
                println("task1, task2, task3: completed")
            }
            .add(task4 <--> task5)
            .progress { bytes, total in
                println("concurrent tasks")
            }
            .resume()

```

``` swift
// downloading task

let task = DownloadTask(url: downloadUrl, destination: des)
	.progress { bytes, total in
		let per = Double(bytes) / Double(total)
		println("downloading: \(per)")
	}
	.completed { response, json, error in
		println("completed")
	}


// uploading task
// upload types: File, Data, Stream

let task = UploadTask(url: "http://server.com", data: uploadData)
	.progress { sent, total in
		let per = Double(sent) / Double(total)
		println("uploading: \(per)")
	}
	.completed { response, _, error in
		println("completed")
	}


// task

task.headers = ["key": "value"]
task.params = ["key": "value"]
task.suspend
task.cancel
task.retry

// background handling
// add the following method in the app delegate

func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
	Transporter.handleEventsForBackgroundURLSection(identifier, completionHandler: completionHandler)
    }


// Transporter configurations

Transporter.headers = [key: value]
Transporter.timeoutIntervalForRequest = 30.0
Transporter.timeoutIntervalForResource = 60.0
Transporter.HTTPMaximumconnectionsPerHost = 5
			
```


Installation
-----
* Installation with CocoaPods

```
	// coming soon
```

* Copying all the files into your project
* Using submodule

Requirements
-----
- iOS 7.0+
- Xcode 6.1

License
-----

Transporter is released under the MIT license. See LICENSE for details.
