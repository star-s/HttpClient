//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.09.2021.
//

import Foundation

public protocol PathExpressibleByInterpolation: ExpressibleByStringInterpolation where StringInterpolation: PathInterpolationProtocol {}

public protocol PathInterpolationProtocol: StringInterpolationProtocol where StringLiteralType == String {
	mutating func appendInterpolation<T>(_ value: T)
}

extension String: PathExpressibleByInterpolation {}
extension DefaultStringInterpolation: PathInterpolationProtocol {}
