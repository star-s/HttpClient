//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities

public struct JsonRequestEncoder: CustomizableRequestEncoder {
    public let headersFactory: HeadersFactory
	public let queryEncoder: URLQueryEncoder
	public let bodyEncoder: JSONEncoder

	public init(
        headersFactory: HeadersFactory = HTTPHeaders.default,
		queryEncoder: URLQueryEncoder = URLQueryEncoder(),
		bodyEncoder: JSONEncoder = JSONEncoder()
	) {
        self.headersFactory = headersFactory
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }

    public init(
        headers: HTTPHeaders = .default,
        headersAuthorizer: HeadersAuthorizer,
        queryEncoder: URLQueryEncoder = URLQueryEncoder(),
        bodyEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.headersFactory = headers.factory(with: headersAuthorizer)
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
}
