//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation
import URLEncodedForm
import HttpClientUtilities

public protocol OAuth2PresentationLayer: PresentationLayer {
	var settings: OAuth2Settings { get }
	var headers: HTTPHeaders { get }
}

public extension OAuth2PresentationLayer {

	var headers: HTTPHeaders { .default }

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: headers)
			.with(method: .post)
			.with(body: .formURLEncoded(parameters))
	}
}
