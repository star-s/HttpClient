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
	public struct Factory: HeadersFactory {
		private let headers: () throws -> HTTPHeaders

        public init(_ headers: @escaping () throws -> HTTPHeaders) {
			self.headers = headers
		}

		public func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders {
			try headers()
		}
	}
}

extension HTTPHeaders: HeadersFactory {
    @inlinable
    public func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders {
        self
    }
}
