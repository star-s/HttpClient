//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.04.2021.
//

import Foundation
import HttpClientUtilities

public extension TransportLayer {
	func transportWithLogger(_ logger: @escaping () -> TransportLogger) -> TransportLoggerAdapter<Self> {
		TransportLoggerAdapter(transport: self, logger: logger)
	}

	func transportWithDefaultLogger() -> TransportLoggerAdapter<Self> {
		TransportLoggerAdapter(transport: self) {
			DefaultLogger(sessionConfiguration: .default)
		}
	}
}

public struct TransportLoggerAdapter<T: TransportLayer>: TransportLayer {
	private let transport: T
	private let logger: () -> TransportLogger

	public init(transport: T, logger: @escaping () -> TransportLogger) {
		self.transport = transport
		self.logger = logger
	}

	public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		let logger = logger()
		logger.log(request: request)
		do {
			let response = try await transport.perform(request)
			logger.log(result: .success(response))
			return response
		} catch {
			logger.log(result: .failure(error))
			throw error
		}
	}
}
