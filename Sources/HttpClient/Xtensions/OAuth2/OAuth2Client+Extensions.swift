//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

#if os(macOS) || os(iOS)
import AuthenticationServices

public extension OAuth2Client {
    @MainActor
    func startWebAuthenticationSession<T: AccessToken>(
        _ returnType: T.Type = T.self,
        responseType: ResponseType,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
        ephemeralWebBrowser: Bool = true,
        state: String? = nil
    ) async throws -> T {
        let url = try prepareAuthorizationURL(responseType: responseType, state: state)
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: self.redirectURL.scheme) { url, error in
                Task {
                    do {
                        if let error = error {
                            throw error
                        }
                        guard let url = url else {
                            throw OAuth2ClientError.wrongRedirectURL
                        }
                        let token: T
                        switch responseType {
                        case .code:
                            let response = try self.decodeAuthorizationCode(redirect: url, state: state)
                            token = try await self.accessToken(response.code)
                        case .token:
                            token = try self.decodeAccessToken(redirect: url, state: state)
                        }
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            session.presentationContextProvider = presentationContextProvider
            session.prefersEphemeralWebBrowserSession = ephemeralWebBrowser
            session.start()
        }
    }
}
#endif

public extension OAuth2Client {

    // MARK: Prepare URL

    func prepareAuthorizationURL(responseType: ResponseType, state: String?) throws -> URL {
        let request = AuthorizationRequest(
            type: responseType,
            clientID: clientID,
            redirectURL: redirectURL,
            scope: scope
        )
        let encoder = URLQueryEncoder(arrayEncoding: .noBrackets)

        let query: String
        if let state {
            query = try encoder.encode(StateWrapper(request, state: state))
        } else {
            query = try encoder.encode(request)
        }
        return try makeURL(from: authorizationEndpoint).appendingQuery(query)
    }

    // MARK: Decode redirect URL

    /// https://www.rfc-editor.org/rfc/rfc6749#section-4.1
    /// 4.1.  Authorization Code Grant
    func decodeAuthorizationCode(redirect: URL, state: String?) throws -> AuthorizationCode {
        guard let query = redirect.query else {
            throw OAuth2ClientError.wrongRedirectURL
        }
        let decoder = URLEncodedFormDecoder()

        guard let state else {
            return try decoder.decode(OAuth2Response<AuthorizationCode, AuthorizationError>.self, from: query).result.get()
        }
        let response = try decoder.decode(StateWrapper<OAuth2Response<AuthorizationCode, AuthorizationError>>.self, from: query)
        guard response.state == state else {
            throw OAuth2ClientError.stateMismatch
        }
        return try response.value.result.get()
    }

    /// https://www.rfc-editor.org/rfc/rfc6749#section-4.2
    /// 4.2.  Implicit Grant
    func decodeAccessToken<T: AccessToken>(redirect: URL, state: String?) throws -> T {
        guard let fragment = redirect.fragment else {
            throw OAuth2ClientError.wrongRedirectURL
        }
        let decoder = URLEncodedFormDecoder()
        guard let state else {
            return try decoder.decode(OAuth2Response<T, AuthorizationError >.self, from: fragment).result.get()
        }
        let response = try decoder.decode(StateWrapper<OAuth2Response<T, AuthorizationError>>.self, from: fragment)
        guard response.state == state else {
            throw OAuth2ClientError.stateMismatch
        }
        return try response.value.result.get()
    }

    // MARK: Obtain access token

    func accessToken<T: AccessToken>(_ code: String) async throws -> T {
        let request = AccessTokenRequest.authorizationCode(
            code,
            clientID: clientID,
            redirectURI: redirectURL
        )
        return try await post(tokenEndpoint, parameters: request)
    }

    func accessTokenWithClientCredentials<T: AccessToken>() async throws -> T {
        let request = AccessTokenRequest.clientCredentials(scope: scope)
        return try await post(tokenEndpoint, parameters: request)
    }

    func accessTokenWithPassword<T: AccessToken>(username: String, password: String) async throws -> T {
        let request = AccessTokenRequest.password(username: username, password: password, scope: scope)
        return try await post(tokenEndpoint, parameters: request)
    }

    // MARK: Refresh acces token

    func refreshToken<T: AccessToken>(_ refreshToken: String) async throws -> T {
        let request = AccessTokenRequest.refreshToken(refreshToken, scope: scope)
        return try await post(tokenEndpoint, parameters: request)
    }
}
