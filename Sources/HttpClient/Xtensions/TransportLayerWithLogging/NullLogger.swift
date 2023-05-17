//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.05.2023.
//

import Foundation

public struct NullLogger: TransportLogger {
	public init() {}

	public func log(request: URLRequest) {}
	public func log(result: Result<(data: Data, response: URLResponse), Error>) {}
}
