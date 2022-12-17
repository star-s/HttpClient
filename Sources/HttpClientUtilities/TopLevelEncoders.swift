//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine
import URLEncodedForm

extension URLEncodedFormEncoder: TopLevelEncoder {}

extension URLQueryEncoder: TopLevelEncoder {
    public typealias Output = String

    public func encode<T: Encodable>(_ value: T) throws -> String {
        try encode(value)
    }
}
