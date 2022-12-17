//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine

extension URLEncodedFormEncoder: TopLevelEncoder {
    public typealias Output = String

    public func encode<T: Encodable>(_ value: T) throws -> String {
        try encode(value)
    }
}
