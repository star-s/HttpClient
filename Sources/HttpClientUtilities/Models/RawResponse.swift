//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.10.2021.
//

import Foundation

public struct RawResponse: RawRepresentable, Decodable {
	public let rawValue: Data

	public init(rawValue: Data) {
		self.rawValue = rawValue
	}
}
