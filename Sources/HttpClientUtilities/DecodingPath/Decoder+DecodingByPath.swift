//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.02.2021.
//

import Foundation

extension Decoder {
    
    func nestedContainer<K: CodingKey>(forDecodingPath keys: [K]) throws -> KeyedDecodingContainer<K> {
        try keys.reduce(container(keyedBy: K.self)) { try $0.nestedContainer(keyedBy: K.self, forKey: $1) }
    }

    public func decode<T: Decodable, K: CodingKey>(_ type: T.Type, byDecodingPath keys: [K]) throws -> T {
        var keys = keys
        guard let valueKey = keys.popLast() else {
            return try T.init(from: self)
        }
        guard let OptionalT = T.self as? _OptionalProtocol.Type else {
            return try nestedContainer(forDecodingPath: keys).decode(T.self, forKey: valueKey)
        }
        guard let value = try? nestedContainer(forDecodingPath: keys).decode(T.self, forKey: valueKey) else {
            return OptionalT.init(nilLiteral: ()) as! T
        }
        return value
    }
}

private protocol _OptionalProtocol: ExpressibleByNilLiteral {}
extension Optional: _OptionalProtocol {}
