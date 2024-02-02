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

struct OpenRpc<T: TransportLayer>: HttpClientWithBaseUrl, JsonRpcService {
	typealias Path = String

	let presenter = JsonPresenter()

	var transport: T
	var baseURL: URL
	var endpoint: String

	init(
		transport: T = URLSession.shared.transportWithDefaultLogger(),
		baseURL: URL = .openRpcBaseURL,
		endpoint: String
	) {
		self.transport = transport
		self.baseURL = baseURL
		self.endpoint = endpoint
	}
}
