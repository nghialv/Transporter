# Transporter

uploading and downloading lib
------

- multiple files (parallel, serial)
- progress
- retry
- timeout
- header settings
- background
- LlamaKit (https://github.com/LlamaKit/LlamaKit)

``` swift

Transporter.handleEventsForBackgroundURLSection(identifier: String, completionHandler: ( ) -> ( ))

let task1 = UploadTask(file: String)
					.progress { byteswritten, totalbytes in
					
					}
					.completed { result in
					
					}
task1.method = .Post
task1.retry = true
task1.timeout = 10
task1.headers = [String: AnyObject]
task1.parameters = [String: AnyObject]

let task2 = UploadTask(data: NSData)
					.progress()
					.completed()

let task3 = DownloadTask(url: "")
					.progress()
					.completed()

Transporter.headers = [:]

Transporter.push(task1)
			.validate()
			.progress()
			.completed()
			.resume()

Transporter.push(task1 -> task2 -> task3)
			.progress()
			.completed()
			.resume()

Transporter.push(task1 <-> task2 <-> task3)
			.progress()
			.completed()
			.resume()
			
```
