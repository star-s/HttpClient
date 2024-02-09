//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities

public struct JsonRequestEncoder: CustomizableRequestEncoder {
	public let queryEncoder: URLQueryEncoder
	public let bodyEncoder: JSONEncoder

	public init(
		queryEncoder: URLQueryEncoder = URLQueryEncoder(),
		bodyEncoder: JSONEncoder = JSONEncoder()
	) {
		self.queryEncoder = queryEncoder
		self.bodyEncoder = bodyEncoder
	}
}
