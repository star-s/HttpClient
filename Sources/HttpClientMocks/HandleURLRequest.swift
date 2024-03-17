//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.03.2024.
//

import Foundation
import HttpClientUtilities

public func handleURLRequest(_ request: URLRequest, _ dataBuilder: () throws -> TaggedData) throws -> (data: Data, response: URLResponse) {
    guard let url = request.url else {
        throw URLError(.badURL)
    }
    let taggedData = try dataBuilder()
    return (
        taggedData.data,
        HTTPURLResponse(
            url: url,
            mimeType: taggedData.mimeType,
            expectedContentLength: taggedData.data.count,
            textEncodingName: taggedData.textEncoding?.IANACharSetName
        )
    )
}
