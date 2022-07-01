//
//  URL.swift
//
//
//  Created by Sergey Starukhin on 18/09/2019.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
		guard let string = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
				let url = URL(string: string) else {
            preconditionFailure("Invalid URL string: \(value)")
        }
        self = url
    }
}
