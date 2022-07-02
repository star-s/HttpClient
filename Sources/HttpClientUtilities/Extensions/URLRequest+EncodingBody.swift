//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine

public extension URLRequest {
    
	func encodingBody<P: Encodable, C: TopLevelEncoder>(_ parameters: P, coder: C, contentType: String? = nil, charset: String.Encoding? = nil) throws -> URLRequest where C.Output == Data {
		var request = self
		request.httpBody = try coder.encode(parameters)
		contentType.map {
			if let charset = charset?.IANACharSetName {
				request.headers.update(.contentType($0 + "; charset=\(charset)"))
			} else {
				request.headers.update(.contentType($0))
			}
		}
		return request
	}

	func encodingBody<P: Encodable, C: TopLevelEncoder>(_ parameters: P, coder: C, contentType: String? = nil) throws -> URLRequest where C.Output == String {
		var request = self
		request.httpBody = try Data(coder.encode(parameters).utf8)
		if let type = contentType {
			request.setValue(type, forHTTPHeaderField: "Content-Type")
		}
		return request
	}
}
