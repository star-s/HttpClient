//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public struct URLEncodedFormRequestEncoder: CustomRequestEncoder {
    public let defaultHeaders: HTTPHeaders
    public let requestAuthorizer: RequestAuthorizer?
    public let queryEncoder: URLQueryEncoder
    public let bodyEncoder: URLEncodedFormEncoder

    public init(
        defaultHeaders: HTTPHeaders = .default,
        requestAuthorizer: RequestAuthorizer? = nil,
        queryEncoder: URLQueryEncoder = URLQueryEncoder(),
        bodyEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder()
    ) {
        self.defaultHeaders = defaultHeaders
        self.requestAuthorizer = requestAuthorizer
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
}
