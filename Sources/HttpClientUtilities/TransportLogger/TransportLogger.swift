//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.05.2023.
//

import Foundation

public protocol TransportLogger {
	func log(request: URLRequest) -> ResultLogger
}

public protocol ResultLogger {
	func log(result: Result<(data: Data, response: URLResponse), Error>)
}
