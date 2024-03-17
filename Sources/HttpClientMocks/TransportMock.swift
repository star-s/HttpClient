//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.02.2024.
//

import Foundation
import HttpClient

public struct TransportMock: TransportLayer {
	private let requestPerformer: (URLRequest) throws -> (data: Data, response: URLResponse)

	public init(_ methodMock: @escaping (URLRequest) throws -> (data: Data, response: URLResponse)) {
		self.requestPerformer = methodMock
	}

	public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		try requestPerformer(request)
	}
}
