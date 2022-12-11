//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation
import URLEncodedForm

public protocol OAuth2PresentationLayer: PresentationLayer {
	var settings: OAuth2Settings { get }
}

public extension OAuth2PresentationLayer {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .post)
			.with(body: parameters, coder: URLEncodedFormEncoder(), contentType: "application/x-www-form-urlencoded")
	}
}
