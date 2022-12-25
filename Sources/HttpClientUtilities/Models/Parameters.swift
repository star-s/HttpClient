//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2022.
//

import Foundation

public enum Parameters: Encodable {
	case void

	public func encode(to encoder: Encoder) throws {
		struct Void: Encodable {}
		try Void().encode(to: encoder)
	}
}
