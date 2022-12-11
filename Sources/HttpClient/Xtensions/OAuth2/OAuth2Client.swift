//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public protocol OAuth2Client: HttpClientWithBaseUrl where Path == String {
	var settings: OAuth2Settings { get }
}

extension OAuth2Client {
	public var baseURL: URL { settings.baseURL }

	public func prepareAuthorizationURL(responseType: ResponseType, state: String? = nil) throws -> URL {
		let request = AuthorizationRequest(
			type: responseType,
			clientID: settings.clientID,
			scope: settings.scope,
			state: state,
			redirectURL: settings.redirectURL
		)
		let query = try URLEncodedFormEncoder(arrayEncoding: .noBrackets).encode(request) as String
		guard let url = try makeURL(from: settings.authorizationEndpoint).appendingQuery(query) else {
			throw URLError(.badURL)
		}
		return url
	}

	/// https://www.rfc-editor.org/rfc/rfc6749#section-4.1
	/// 4.1.  Authorization Code Grant
	public func decodeAuthorizationResponse(redirect: URL) throws -> AuthorizationResponse {
		guard let query = redirect.query else {
			throw URLError(.badURL)
		}
		return try URLEncodedFormDecoder().decode(AuthorizationResponse.self, from: query)
	}

	/// https://www.rfc-editor.org/rfc/rfc6749#section-4.2
	/// 4.2.  Implicit Grant
	public func decodeAccessTokenResponse(redirect: URL) throws -> AccessTokenResponse {
		guard let fragment = redirect.fragment else {
			throw URLError(.badURL)
		}
		let decoder = URLEncodedFormDecoder()

		guard let token = try? decoder.decode(AccessTokenResponse.self, from: fragment) else {
			throw try decoder.decode(AuthorizationError.self, from: fragment)
		}
		return token
	}

	public func accessToken(_ code: String) async throws -> AccessTokenResponse {
		let request = AccessTokenRequest.authorizationCode(code, clientID: settings.clientID, redirectURI: settings.redirectURL)
		return try await post(settings.tokenEndpoint, parameters: request)
	}

	public func refreshToken(_ refreshToken: String) async throws -> AccessTokenResponse {
		let request = AccessTokenRequest.refreshToken(refreshToken, scope: settings.scope)
		return try await post(settings.tokenEndpoint, parameters: request)
	}

	func accessTokenWithClientCredentials(username: String, password: String) async throws -> AccessTokenResponse {
		let request = AccessTokenRequest.clientCredentials(scope: settings.scope)
		return try await authorizedPost(
			settings.tokenEndpoint,
			parameters: request,
			username: username,
			password: password
		)
	}

	func accessTokenWithPassword(username: String, password: String) async throws -> AccessTokenResponse {
		let request = AccessTokenRequest.password(username: username, password: password, scope: settings.scope)
		return try await authorizedPost(
			settings.tokenEndpoint,
			parameters: request,
			username: username,
			password: password
		)
	}

	func authorizedPost<P: Encodable, T: Decodable>(_ path: Path, parameters: P, username: String, password: String) async throws -> T {
		var request = try await presenter.prepare(post: makeURL(from: path), parameters: parameters)
		request.headers.add(.authorization(username: username, password: password))
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
}
