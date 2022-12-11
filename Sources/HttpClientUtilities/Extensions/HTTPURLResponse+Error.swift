//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02.07.2022.
//

import Foundation

extension HTTPURLResponse: LocalizedError {
	public var errorDescription: String? {
		Self.localizedString(forStatusCode: statusCode)
	}
}

extension URLResponse {
	public func checkStatusCode() throws {
		guard let httpResponse = self as? HTTPURLResponse else {
			return
		}
		guard httpResponse.statusCode == 200 else {
			throw httpResponse
		}
	}
}
