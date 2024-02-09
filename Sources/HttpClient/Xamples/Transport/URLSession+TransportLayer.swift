//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.04.2021.
//

import Foundation

extension URLSession: TransportLayer {
    
    public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		try await withCheckedThrowingContinuation { continuation in
			dataTask(with: request) { (data, response, error) in
				continuation.resume(with: Result {
					if let error = error {
						throw error
					}
					guard let response = response else {
						throw URLError(.badServerResponse)
					}
					return (data ?? Data(), response)
				})
			}.resume()
		}
    }
}
