//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

enum AccessTokenRequest {
	case authorizationCode(String, clientID: String, redirectURI: URL)
	case refreshToken(String, scope: String?)
	case clientCredentials(scope: String?)
	case password(username: String, password: String, scope: String?)
}

extension AccessTokenRequest {
	enum GrantType: String, Encodable {
		case authorizationCode = "authorization_code"
		case refreshToken = "refresh_token"
		case clientCredentials = "client_credentials"
		case password = "password"
	}

	var grantType: GrantType {
		switch self {
		case .authorizationCode:
			return .authorizationCode
		case .refreshToken:
			return .refreshToken
		case .clientCredentials:
			return .clientCredentials
		case .password:
			return .password
		}
	}
}

extension AccessTokenRequest: Encodable {
	private enum CodingKeys: String, CodingKey {
		case grant_type

		case code
		case client_id
		case redirect_uri

		case scope

		case refresh_token

		case username
		case password

	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .authorizationCode(let code, let clientID, let redirectURI):
			try container.encode(code, forKey: .code)
			try container.encode(clientID, forKey: .client_id)
			try container.encode(redirectURI, forKey: .redirect_uri)
		case .refreshToken(let token, let scope):
			try container.encode(token, forKey: .refresh_token)
			try container.encodeIfPresent(scope, forKey: .scope)
		case .clientCredentials(let scope):
			try container.encodeIfPresent(scope, forKey: .scope)
		case .password(let username, let password, let scope):
			try container.encode(username, forKey: .username)
			try container.encode(password, forKey: .password)
			try container.encodeIfPresent(scope, forKey: .scope)
		}
		try container.encode(grantType, forKey: .grant_type)
	}
}
