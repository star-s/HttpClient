//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation

public struct RelativePathHttpClient<P: PresentationLayer, T: TransportLayer>: HttpClientWithBaseUrl {
	public typealias Path = String

	public let presenter: P
	public let transport: T

	public let baseURL: URL

	public init(
		baseURL: URL,
		presenter: P = DefaultPresenter(),
		transport: T = DefaultTransport()
	) {
		self.baseURL = baseURL
		self.presenter = presenter
		self.transport = transport
	}
}
