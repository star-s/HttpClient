//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities

public struct JsonRequestEncoder: CustomRequestEncoder {
    public let defaultHeaders: HTTPHeaders
    public let requestAuthorizer: RequestAuthorizer?
	public let queryEncoder: URLQueryEncoder
	public let bodyEncoder: JSONEncoder

    public init(
        defaultHeaders: HTTPHeaders = .default,
        requestAuthorizer: RequestAuthorizer? = nil,
        queryEncoder: URLQueryEncoder = URLQueryEncoder(),
        bodyEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.defaultHeaders = defaultHeaders
        self.requestAuthorizer = requestAuthorizer
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
}
