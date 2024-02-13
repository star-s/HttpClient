//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2022.
//

import Foundation

public enum Parameters: Encodable {
	case void
	case voidArray
	case null

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
			case .void:
                try container.encode([String:String]())
			case .voidArray:
				try container.encode([String]())
			case .null:
				try container.encodeNil()
		}
	}
}
