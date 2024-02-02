//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.04.2021.
//

import Foundation
import HttpClientUtilities

public extension TransportLayer {
	func transportWithLogger(_ logger: TransportLogger = DefaultTransportLogger(sessionConfiguration: .default)) -> TransportLoggerAdapter<Self> {
		TransportLoggerAdapter(transport: self, logger: logger)
	}
}

public struct TransportLoggerAdapter<T: TransportLayer>: TransportLayer {
	private let transport: T
	private let logger: TransportLogger

	public init(transport: T, logger: TransportLogger) {
		self.transport = transport
		self.logger = logger
	}

	public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		let responseLogger = logger.log(request: request)
		do {
			let response = try await transport.perform(request)
			responseLogger.log(result: .success(response))
			return response
		} catch {
			responseLogger.log(result: .failure(error))
			throw error
		}
	}
}
