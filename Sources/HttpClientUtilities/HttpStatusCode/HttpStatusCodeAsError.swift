//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

extension HttpStatusCode: LocalizedError {
    public var errorDescription: String? {
        HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
}

public extension HttpStatusCode {
    static func ~= (lhs: Self, rhs: Error) -> Bool {
        guard let selfError = rhs as? Self else { return false }
        return selfError == lhs
    }
}
