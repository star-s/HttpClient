//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public typealias DefaultPresenter = JsonPresenter

public struct JsonPresenter: CustomizablePresentationLayer {
	public let bodyEncoder: JSONEncoder
	public let headersFactory: HeadersFactory

	public init(
		bodyEncoder: JSONEncoder = JSONEncoder(),
		headersFactory: HeadersFactory = HTTPHeaders.defaultFactory
	) {
		self.bodyEncoder = bodyEncoder
		self.headersFactory = headersFactory
	}
}

public struct URLEncodedFormPresenter: CustomizablePresentationLayer {
	public let bodyEncoder: URLEncodedFormEncoder
	public let headersFactory: HeadersFactory

	public init(
		bodyEncoder: URLEncodedFormEncoder = URLEncodedFormEncoder(),
		headersFactory: HeadersFactory = HTTPHeaders.defaultFactory
	) {
		self.bodyEncoder = bodyEncoder
		self.headersFactory = headersFactory
	}
}
