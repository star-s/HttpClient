//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities

public struct DefaultTransport: URLSessionTransportLayer {
	public let session: URLSession
	public let loggerFactory: TransportLoggerFactory?

	public init(
		session: URLSession = .shared,
		loggerFactory: TransportLoggerFactory? = DefaultTransportLoggerFactory(sessionConfiguration: .default)
	) {
		self.session = session
		self.loggerFactory = loggerFactory
	}
}
