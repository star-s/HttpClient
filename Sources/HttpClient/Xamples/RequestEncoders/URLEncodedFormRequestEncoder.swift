//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public struct URLEncodedFormRequestEncoder: CustomizableRequestEncoder {
    public var headersFactory: HeadersFactory
    public let queryEncoder: URLQueryEncoder
    public let bodyEncoder: URLEncodedFormEncoder

    public init(
        headersFactory: HeadersFactory = HTTPHeaders.default,
        queryEncoder: URLQueryEncoder = URLQueryEncoder(),
        bodyEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder()
    ) {
        self.headersFactory = headersFactory
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
}
