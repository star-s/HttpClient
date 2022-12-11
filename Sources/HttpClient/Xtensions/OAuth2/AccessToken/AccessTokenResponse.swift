//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

public struct AccessTokenResponse {
	public let accessToken: String
	public let tokenType: AccessTokenType
	public let refreshToken: String?
	public let expiresIn: TimeInterval?
	public let scope: String?
}

extension AccessTokenResponse: Decodable {
	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
		case refreshToken = "refresh_token"
		case expiresIn = "expires_in"
		case scope
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		guard container.contains(.accessToken) else {
			throw try AccessTokenError(from: decoder)
		}
		accessToken = try container.decode(String.self, forKey: .accessToken)
		tokenType = try container.decode(AccessTokenType.self, forKey: .tokenType)
		refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
		expiresIn = try container.decodeIfPresent(TimeInterval.self, forKey: .expiresIn)
		scope = try container.decodeIfPresent(String.self, forKey: .scope)
	}
}
