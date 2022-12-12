//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.12.2022.
//

import Foundation
import Combine

public struct TypedDataDecoder<T: Decodable> {
	private let data: Data
	private let decoder: (Data) throws -> T

	init<D: TopLevelDecoder>(_ data: Data, decoder: @escaping @autoclosure () -> D) where D.Input == Data {
		self.data = data
		self.decoder = { try decoder().decode(T.self, from: $0) }
	}

	public func decode() throws -> T {
		try decoder(data)
	}
}
