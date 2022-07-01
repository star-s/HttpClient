//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.03.2021.
//

import Foundation

public enum DecodingKey {
    case key(String)
    case index(Int)
}

extension DecodingKey: Hashable {}

extension DecodingKey: CodingKey {
    
    public var stringValue: String {
        switch self {
        case .key(let value):
            return value
        case .index(let value):
            return String(value)
        }
    }
    
    public init(stringValue: String) {
        self = .key(stringValue)
    }
    
    public var intValue: Int? {
        switch self {
        case .key(let value):
            return Int(value)
        case .index(let value):
            return value
        }
    }
    
    public init(intValue: Int) {
        self = .index(intValue)
    }
}

extension DecodingKey: ExpressibleByStringLiteral {

    public init(stringLiteral value: StaticString) {
		self = .key(String(describing: value))
    }
}

extension DecodingKey: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self = .index(value)
    }
}
