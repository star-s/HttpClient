//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension HttpStatusCode {
    static let informational: ClosedRange<HttpStatusCode>   = 100...199
    static let successful:    ClosedRange<HttpStatusCode>   = 200...299
    static let redirection:   ClosedRange<HttpStatusCode>   = 300...399
    static let clientError:   ClosedRange<HttpStatusCode>   = 400...499
    static let serverError:   ClosedRange<HttpStatusCode>   = 500...599

    var isInformational: Bool {
        Self.informational.contains(self)
    }

    var isSuccessful: Bool {
        Self.successful.contains(self)
    }

    var isRedirection: Bool {
        Self.redirection.contains(self)
    }

    var isClientError: Bool {
        Self.clientError.contains(self)
    }

    var isServerError: Bool {
        Self.serverError.contains(self)
    }
}
