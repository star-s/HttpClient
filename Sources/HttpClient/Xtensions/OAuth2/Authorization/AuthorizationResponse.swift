//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation

public struct AuthorizationResponse {
	public let code: String
	public let state: String?
}

extension AuthorizationResponse: Decodable {
	private enum CodingKeys: String, CodingKey {
		case code
		case state
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		guard container.contains(.code) else {
			throw try AuthorizationError(from: decoder)
		}
		code = try container.decode(String.self, forKey: .code)
		state = try container.decodeIfPresent(String.self, forKey: .state)
	}
}
