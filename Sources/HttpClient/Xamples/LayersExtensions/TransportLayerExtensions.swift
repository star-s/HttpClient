//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation
import HttpClientUtilities

public extension TransportLayer {

    func withLogger(
        _ logger: TransportLogger = DefaultTransportLogger(sessionConfiguration: .default)
    ) -> TransportLoggerAdapter<Self> {
        TransportLoggerAdapter(transport: self, logger: logger)
    }

    func withRetrier(
        _ closure: @escaping (_ request: URLRequest, _ error: Error) async -> Bool
    ) -> TransportWithRetrier<Self> {
        TransportWithRetrier(transport: self, shouldRetry: closure)
    }

    func eraseToAnyTransport() -> AnyTransport {
        AnyTransport(self)
    }
}
