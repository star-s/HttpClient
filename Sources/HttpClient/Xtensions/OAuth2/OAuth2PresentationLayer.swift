//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation
import Combine

public typealias OAuth2RequestEncoder = URLEncodedFormRequestEncoder

public struct OAuth2ResponseDecoder<D: TopLevelDecoder>: ResponseDecoder where D.Input == Data {
    private let decoder: D

    public init(_ decoder: D = JSONDecoder()) {
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return
        }
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 400...599:
            throw try decoder.decode(AccessTokenError.self, from: response.data)
        default:
            throw httpResponse
        }
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        try decoder.decode(OAuth2Response<T>.self, from: response.data).result.get()
    }
}
