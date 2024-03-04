//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

// https://www.ietf.org/rfc/rfc2616.txt

/// The HTTP status code. See RFC 2616 for details.
public struct HttpStatusCode: RawRepresentable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension HttpStatusCode: Hashable {}

extension HttpStatusCode: Comparable {
    public static func < (lhs: HttpStatusCode, rhs: HttpStatusCode) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension HttpStatusCode: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        rawValue = value
    }
}
