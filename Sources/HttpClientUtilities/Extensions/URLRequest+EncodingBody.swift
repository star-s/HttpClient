//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine

public extension URLRequest {

	func with<P: Encodable, C: TopLevelEncoder>(body parameters: P, coder: C, contentType: String? = nil, charset: String.Encoding? = nil) throws -> URLRequest where C.Output == Data {
		var request = self
		request.httpBody = try coder.encode(parameters)
		if let contentType = contentType {
			if let charset = charset?.IANACharSetName {
				request.headers.update(.contentType(contentType + "; charset=\(charset)"))
			} else {
				request.headers.update(.contentType(contentType))
			}
		}
		return request
	}

	func with<P: Encodable, C: TopLevelEncoder>(body parameters: P, coder: C, contentType: String? = nil) throws -> URLRequest where C.Output == String {
		var request = self
		request.httpBody = try Data(coder.encode(parameters).utf8)
		if let type = contentType {
			request.setValue(type, forHTTPHeaderField: "Content-Type")
		}
		return request
	}
}
