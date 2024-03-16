//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02.03.2024.
//

import Foundation

public struct TransportWithRetrier<T: TransportLayer>: TransportLayer {
    private let transport: T
    private let shouldRetry: (_ request: URLRequest, _ error: Error) async -> Bool

    init(transport: T, shouldRetry: @escaping (_ request: URLRequest, _ error: Error) async -> Bool) {
        self.transport = transport
        self.shouldRetry = shouldRetry
    }

    public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        do {
            return try await transport.perform(request)
        } catch {
            guard await shouldRetry(request, error) else {
                throw error
            }
            return try await perform(request)
        }
    }
}
