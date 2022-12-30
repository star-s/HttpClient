//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

extension OAuth2Client {
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
}

extension OAuth2Client where Self: HttpClientWithBaseUrl, Presenter: OAuth2PresentationLayer, Path == String {

	public var baseURL: URL {
		presenter.settings.baseURL
	}

	public var callbackURL: URL {
		presenter.settings.redirectURL
	}

	public func prepareAuthorizationURL(responseType: ResponseType, state: String?) throws -> URL {
		let settings = presenter.settings
		let request = AuthorizationRequest(
			type: responseType,
			clientID: settings.clientID,
			scope: settings.scope,
			state: state,
			redirectURL: settings.redirectURL
		)
		let query = try URLQueryEncoder(arrayEncoding: .noBrackets).encode(request) as String
		return try makeURL(from: settings.authorizationEndpoint).appendingQuery(query)
	}

	public func accessToken(_ code: String) async throws -> AccessTokenResponse {
		let settings = presenter.settings
		let request = AccessTokenRequest.authorizationCode(
			code,
			clientID: settings.clientID,
			redirectURI: settings.redirectURL
		)
		return try await post(settings.tokenEndpoint, parameters: request)
	}

	public func refreshToken(_ refreshToken: String) async throws -> AccessTokenResponse {
		let settings = presenter.settings
		let request = AccessTokenRequest.refreshToken(refreshToken, scope: settings.scope)
		return try await post(settings.tokenEndpoint, parameters: request)
	}

	func accessTokenWithClientCredentials(username: String, password: String) async throws -> AccessTokenResponse {
		let settings = presenter.settings
		let request = AccessTokenRequest.clientCredentials(scope: settings.scope)
		return try await post(settings.tokenEndpoint, parameters: request)
	}

	func accessTokenWithPassword(username: String, password: String) async throws -> AccessTokenResponse {
		let settings = presenter.settings
		let request = AccessTokenRequest.password(username: username, password: password, scope: settings.scope)
		return try await post(settings.tokenEndpoint, parameters: request)
	}
}
