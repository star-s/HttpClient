//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.07.2022.
//

import Foundation

public protocol URLSessionTransportLayerWithLogging: URLSessionTransportLayer {
	associatedtype Logger: TransportLogger

	var logger: Logger { get }
}

public extension URLSessionTransportLayerWithLogging where Self: TransportLogger {
	var logger: Self { self }
}

public extension URLSessionTransportLayerWithLogging {
	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		logger.log(request: request)
		let start = Date()
		do {
			let response = try await urlSession.perform(request)
			logger.log(result: .success(response), of: request, taskInterval: DateInterval(start: start, end: Date()))
			return response
		} catch {
			logger.log(result: .failure(error), of: request, taskInterval: DateInterval(start: start, end: Date()))
			throw error
		}
	}
}
