//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 31.12.2022.
//

import Foundation

public protocol OAuth2Client: HttpClient {

	var authorizationEndpoint: Path { get }
	var tokenEndpoint: Path { get }

	var redirectURL: URL { get }

	var clientID: String { get }
	var clientSecret: String? { get }

	var scope: String { get }

	func prepareAuthorizationURL(responseType: ResponseType, state: String?) throws -> URL

	func decodeAuthorizationResponse(redirect: URL) throws -> AuthorizationResponse
	func decodeAccessTokenResponse(redirect: URL) throws -> AccessTokenResponse

	func accessToken(_ code: String) async throws -> AccessTokenResponse
	func refreshToken(_ refreshToken: String) async throws -> AccessTokenResponse
}

#if os(macOS) || os(iOS)
import AuthenticationServices

public extension OAuth2Client {
	@MainActor
	func startWebAuthenticationSession(
		responseType: ResponseType,
		presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
		ephemeralWebBrowser: Bool = true
	) async throws -> AccessTokenResponse {
		let url = try prepareAuthorizationURL(responseType: responseType, state: nil)
		return try await withCheckedThrowingContinuation { continuation in
			let session = ASWebAuthenticationSession(url: url, callbackURLScheme: self.redirectURL.scheme) { url, error in
				do {
					if let error = error {
						throw error
					}
					guard let url = url else {
						throw URLError(.badURL)
					}
					Task {
						switch responseType {
						case .code:
							let response = try self.decodeAuthorizationResponse(redirect: url)
							let token = try await self.accessToken(response.code)
							continuation.resume(returning: token)
						case .token:
							let token = try self.decodeAccessTokenResponse(redirect: url)
							continuation.resume(returning: token)
						}
					}
				} catch {
					continuation.resume(throwing: error)
				}
			}
			session.presentationContextProvider = presentationContextProvider
			session.prefersEphemeralWebBrowserSession = ephemeralWebBrowser
			session.start()
		}
	}
}
#endif
