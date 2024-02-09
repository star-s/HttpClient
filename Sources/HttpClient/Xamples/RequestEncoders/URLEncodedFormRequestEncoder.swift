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
    public let queryEncoder: URLQueryEncoder
    public let bodyEncoder: URLEncodedFormEncoder

    public init(
        queryEncoder: URLQueryEncoder = URLQueryEncoder(),
        bodyEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder()
    ) {
        self.queryEncoder = queryEncoder
        self.bodyEncoder = bodyEncoder
    }
}
