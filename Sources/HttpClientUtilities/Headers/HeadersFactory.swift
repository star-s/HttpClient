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
	private struct Factory: HeadersFactory {
		private let headers: () async throws -> HTTPHeaders

        public init(_ headers: @escaping () async throws -> HTTPHeaders) {
			self.headers = headers
		}

		public func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders {
            try await headers()
		}
	}

    public func factory(with authorizer: HeadersAuthorizer) -> HeadersFactory {
        Factory {
            try await authorizer.authorize(headers: self)
        }
    }
}

extension HTTPHeaders: HeadersFactory {
    @inlinable
    public func makeHeaders(for url: URL, method: HTTPMethod) async throws -> HTTPHeaders {
        self
    }
}
