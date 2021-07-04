//
//  main.swift
//  ScanUtil
//
//  Created by Михаил Фокин on 02.07.2021.
//

import Foundation
import Kitura

let port = 8090

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    if let path = request.queryParameters["path"] {
        print("Request received:", path)
        if path == "exit" {
            print("Server stop.")
            Kitura.stop()
            exit(0)
        }
        let scanUtil = ScanUtil()
        response.send(scanUtil.run(path: path))
    } else {
        response.send("Invalid request.")
    }
    next()
}

print("Server start.")
// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
