//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 27.01.2024.
//

import Foundation

public protocol HeadersFactory {
	func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders
}

extension HTTPHeaders {
	public struct SimpleFactory: HeadersFactory {
		private let headers: HTTPHeaders

		public init(headers: HTTPHeaders) {
			self.headers = headers
		}

		public func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders {
			headers
		}
	}

	public static let defaultFactory: HeadersFactory = SimpleFactory(headers: .default)
}
