//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation
import HttpClient

extension URL {
	static let openRpcBaseURL: URL = "https://mock.open-rpc.org"
}

struct OpenRpc<T: TransportLayer>: HttpClientWithBaseURL, JsonRpcService {
	typealias Path = String

	let requestEncoder = JsonRpcRequestEncoder()
    let responseDecoder = JsonRpcResponseDecoder() { response, _ in
        try response.asHTTPURLResponse().checkHttpStatusCode()
    }

	let transport: T

	let baseURL: URL
	let endpoint: String

	init(
		transport: T = URLSession.shared.withLogger(),
		baseURL: URL = .openRpcBaseURL,
		endpoint: String
	) {
		self.transport = transport
		self.baseURL = baseURL
		self.endpoint = endpoint
	}
}
