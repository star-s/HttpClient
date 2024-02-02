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

struct OpenRpc: HttpClientWithBaseUrl, JsonRpcService {
	typealias Path = String

	let presenter = JsonPresenter()
	let transport = DefaultTransport()

	var baseURL: URL = .openRpcBaseURL

	var endpoint: String
}
