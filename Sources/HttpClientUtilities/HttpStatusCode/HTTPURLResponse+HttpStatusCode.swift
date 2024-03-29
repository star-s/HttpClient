//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension HTTPURLResponse {

    @inlinable
    var httpStatusCode: HttpStatusCode {
        HttpStatusCode(rawValue: statusCode)
    }

    @inlinable
    convenience init?(
        url: URL,
        httpStatusCode: HttpStatusCode,
        httpVersion HTTPVersion: String?,
        headerFields: [String : String]?
    ) {
        self.init(
            url: url,
            statusCode: httpStatusCode.rawValue,
            httpVersion: HTTPVersion,
            headerFields: headerFields
        )
    }

    @inlinable
    func checkHttpStatusCode<R: RangeExpression>(
        _ validCodes: R = HttpStatusCode.Class.successful.range
    ) throws where R.Bound == HttpStatusCode {
        guard validCodes.contains(httpStatusCode) else {
            throw httpStatusCode
        }
    }
}
