//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.05.2023.
//

import Foundation


public protocol TransportLogger {
	func log(request: URLRequest)
	func log(result: Result<(data: Data, response: URLResponse), Error>)
}

public protocol TransportLayerWithLogging: TransportLayer {
	var logger: TransportLogger { get }
}
