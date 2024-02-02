//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 26.01.2024.
//

import Foundation

public struct DefaultHttpClient<P: PresentationLayer, T: TransportLayer>: HttpClient {
	public typealias Path = URL

	public let presenter: P
	public let transport: T

	public init(
		presenter: P = JsonPresenter(),
		transport: T = URLSession.shared.transportWithLogger()
	) {
		self.presenter = presenter
		self.transport = transport
	}
}
