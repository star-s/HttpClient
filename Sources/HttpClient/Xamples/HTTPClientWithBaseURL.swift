//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation

public struct HTTPClientWithBaseURL<E: RequestEncoder, D: ResponseDecoder, T: TransportLayer>: HttpClientWithBaseUrl {
	public typealias Path = String

	public let requestEncoder: E
    public let responseDecoder: D

	public let transport: T

	public let baseURL: URL

	public init(
		baseURL: URL,
        requestEncoder: E = JsonRequestEncoder(),
        responseDecoder: D = DefaultResponseDecoder(),
		transport: T = URLSession.shared.withLogger()
	) {
		self.baseURL = baseURL
		self.requestEncoder = requestEncoder
        self.responseDecoder = responseDecoder
		self.transport = transport
	}
}
