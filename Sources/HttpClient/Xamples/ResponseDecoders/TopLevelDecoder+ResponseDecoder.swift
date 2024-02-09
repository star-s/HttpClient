//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation
import Combine
import HttpClientUtilities
import URLEncodedForm

extension ResponseDecoder where Self: TopLevelDecoder, Input == Data {

    public func validate(response: (data: Data, response: URLResponse)) async throws {}

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        if T.self is TaggedData.Type {
            return response.data.tagged(with: response.response.tags) as! T
        }
        return try decode(T.self, from: response.data)
    }
}

extension JSONDecoder: ResponseDecoder {}
extension URLEncodedFormDecoder: ResponseDecoder {}
extension PlaintextDecoder: ResponseDecoder {}
extension DataOnlyDecoder: ResponseDecoder {}
