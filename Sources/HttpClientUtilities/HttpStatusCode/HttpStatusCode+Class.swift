//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension HttpStatusCode {
    enum Class: CaseIterable {
        case informational
        case successful
        case redirection
        case clientError
        case serverError

        @inlinable
        public var range: ClosedRange<HttpStatusCode> {
            switch self {
            case .informational:
                return 100...199
            case .successful:
                return 200...299
            case .redirection:
                return 300...399
            case .clientError:
                return 400...499
            case .serverError:
                return 500...599
            }
        }
    }

    @inlinable
    var `class`: Class {
        guard let result = Class.allCases.first(where: { $0.range.contains(self) }) else {
            fatalError("Wrong status code \(rawValue)")
        }
        return result
    }

    @inlinable
    var isInformational: Bool {
        self.class == .informational
    }

    @inlinable
    var isSuccessful: Bool {
        self.class == .successful
    }

    @inlinable
    var isRedirection: Bool {
        self.class == .redirection
    }

    @inlinable
    var isClientError: Bool {
        self.class == .clientError
    }

    @inlinable
    var isServerError: Bool {
        self.class == .serverError
    }
}
