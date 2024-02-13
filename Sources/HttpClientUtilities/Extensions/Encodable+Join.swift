//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation

public extension Encodable {
    func join<T: Encodable>(with value: T) -> some Encodable {
        JoinedValues(self, value)
    }

    func joinIfPresent<T: Encodable>(value: T?) -> some Encodable {
        JoinedValues(self, value)
    }
}

fileprivate struct JoinedValues {
    let encodeValue: (Encoder) throws -> Void
    let encodeJoinedValue: ((Encoder) throws -> Void)?

    init<T1: Encodable, T2: Encodable>(_ value: T1, _ joinedValue: T2?) {
        encodeValue = { try value.encode(to: $0) }
        if let joinedValue {
            encodeJoinedValue = { try joinedValue.encode(to: $0) }
        } else {
            encodeJoinedValue = nil
        }
    }
}

extension JoinedValues: Encodable {
    func encode(to encoder: Encoder) throws {
        try encodeValue(encoder)
        try encodeJoinedValue?(encoder)
    }
}
