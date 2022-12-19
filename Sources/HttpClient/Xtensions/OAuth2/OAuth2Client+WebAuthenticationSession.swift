//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 19.12.2022.
//

import Foundation
#if os(macOS) || os(iOS)
import AuthenticationServices

public extension OAuth2Client {
	@MainActor
	func startWebAuthenticationSession(
		responseType: ResponseType,
		presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
		ephemeralWebBrowser: Bool = true
	) async throws -> AccessTokenResponse {
		let url = try prepareAuthorizationURL(responseType: responseType)
		let callbackURL = presenter.settings.redirectURL
		return try await withCheckedThrowingContinuation { continuation in
			let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURL.scheme) { url, error in
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
