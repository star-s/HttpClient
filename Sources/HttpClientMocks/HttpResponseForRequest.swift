//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.03.2024.
//

import Foundation
import HttpClientUtilities

public func httpResponse(
    for request: URLRequest,
    statusCode: HttpStatusCode,
    headers: HTTPHeaders? = nil,
    data: Data = Data()
) -> (data: Data, response: URLResponse) {
    guard let url = request.url else {
        fatalError("URL must not be nil!")
    }
    guard let response = HTTPURLResponse(
        url: url,
        httpStatusCode: statusCode,
        httpVersion: nil,
        headerFields: headers?.dictionary
    ) else {
        fatalError("Can't make response")
    }
    return (data, response)
}

public func httpResponse(
    for request: URLRequest,
    data: TaggedData
) -> (data: Data, response: URLResponse) {
    guard let url = request.url else {
        fatalError("URL must not be nil!")
    }
    let response = HTTPURLResponse(
        url: url,
        mimeType: data.mimeType,
        expectedContentLength: data.data.count,
        textEncodingName: data.textEncoding?.IANACharSetName
    )
    return (data.data, response)
}
