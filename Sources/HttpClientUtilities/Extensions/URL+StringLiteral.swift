//
//  URL.swift
//
//
//  Created by Sergey Starukhin on 18/09/2019.
//

import Foundation

extension URL: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
		guard let url = value
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap(URL.init(string:))
        else {
            preconditionFailure("Invalid URL string: \(value)")
        }
        self = url
    }
}
