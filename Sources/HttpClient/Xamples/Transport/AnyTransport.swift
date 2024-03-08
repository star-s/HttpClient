//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02.03.2024.
//

import Foundation

public struct AnyTransport: TransportLayer {
    private let transport: (URLRequest) async throws -> (data: Data, response: URLResponse)

    public init<T: TransportLayer>(_ transport: T) {
        self.transport = {
            try await transport.perform($0)
        }
    }

    public init(_ transport: @escaping (URLRequest) async throws -> (data: Data, response: URLResponse)) {
        self.transport = transport
    }

    public func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        try await transport(request)
    }
}

public extension TransportLayer {
    func eraseToAnyTransport() -> AnyTransport {
        AnyTransport(self)
    }
}
