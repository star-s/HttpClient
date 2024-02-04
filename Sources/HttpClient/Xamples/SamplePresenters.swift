//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public struct JsonPresenter: CustomizablePresentationLayer {
	public let headersFactory: HeadersFactory
	public let bodyEncoder: JSONEncoder

	public init(
		headersFactory: HeadersFactory = HTTPHeaders.defaultFactory,
		bodyEncoder: JSONEncoder = JSONEncoder()
	) {
		self.headersFactory = headersFactory
		self.bodyEncoder = bodyEncoder
	}
}

public struct URLEncodedFormPresenter: CustomizablePresentationLayer {
	public let headersFactory: HeadersFactory
	public let bodyEncoder: URLEncodedFormEncoder

	public init(
		headersFactory: HeadersFactory = HTTPHeaders.defaultFactory,
		bodyEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder()
	) {
		self.headersFactory = headersFactory
		self.bodyEncoder = bodyEncoder
	}
}
