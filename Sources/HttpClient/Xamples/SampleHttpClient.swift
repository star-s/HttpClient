//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation

public struct SampleHttpClient<E: RequestEncoder, D: ResponseDecoder, T: TransportLayer>: HttpClient {
	public typealias Path = URL

	public let requestEncoder: E
    public let responseDecoder: D

	public let transport: T

	public init(
        requestEncoder: E = JsonRequestEncoder().withUpdatedHeaders(),
        responseDecoder: D = DefaultResponseDecoder().withDefaultResponseValidator(),
		transport: T = URLSession.shared.withLogger()
	) {
		self.requestEncoder = requestEncoder
        self.responseDecoder = responseDecoder
		self.transport = transport
	}
}
