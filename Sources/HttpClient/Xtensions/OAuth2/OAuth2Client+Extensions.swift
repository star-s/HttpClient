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
        _ responseType: T.Type = T.self,
        flow: Flow,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
        ephemeralWebBrowser: Bool = true,
        state: String? = nil
    ) async throws -> T {
        let redirectURL = try await ASWebAuthenticationSession.start(
            with: prepareAuthorizationURL(flow: flow, state: state),
            callbackURL: callbackURL,
            presentationContextProvider: presentationContextProvider,
            ephemeralWebBrowser: ephemeralWebBrowser
        )
        switch flow {
        case .authorizationCode:
            let response = try self.decodeAuthorizationCode(redirect: redirectURL, state: state)
            return try await self.accessToken(code: response.code)
        case .implicit:
            return try self.decodeAccessToken(redirect: redirectURL, state: state)
        }
    }
}
#endif

public enum Flow {
    case implicit
    case authorizationCode
}

public extension OAuth2Client {

    // MARK: Prepare URL

    func prepareAuthorizationURL(flow: Flow, state: String?) throws -> URL {
        let request = AuthorizationRequest(
            type: flow.responseType,
            clientID: clientID,
            redirectURL: callbackURL,
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

    func accessToken<T: AccessToken, P: Encodable>(code: String, _ params: P = Parameters.void) async throws -> T {
        let request = AccessTokenRequest.authorizationCode(
            code,
            clientID: clientID,
            redirectURI: callbackURL
        )
        return try await post(tokenEndpoint, parameters: request.withAdditionalParameters(params))
    }

    func accessToken<T: AccessToken, P: Encodable>(secret: String, _ params: P = Parameters.void) async throws -> T {
        let request = AccessTokenRequest.clientCredentials(clientID: clientID, clientSecret: secret, scope: scope)
        return try await post(tokenEndpoint, parameters: request.withAdditionalParameters(params))
    }

    func accessToken<T: AccessToken, P: Encodable>(username: String, password: String, _ params: P = Parameters.void) async throws -> T {
        let request = AccessTokenRequest.password(username: username, password: password, scope: scope)
        return try await post(tokenEndpoint, parameters: request.withAdditionalParameters(params))
    }

    // MARK: Refresh acces token

    func refreshToken<T: AccessToken, P: Encodable>(_ refreshToken: String, _ params: P = Parameters.void) async throws -> T {
        let request = AccessTokenRequest.refreshToken(refreshToken, scope: scope)
        return try await post(tokenEndpoint, parameters: request.withAdditionalParameters(params))
    }
}

private extension Flow {
    var responseType: AuthorizationRequest.ResponseType {
        switch self {
            case .implicit:
                return .token
            case .authorizationCode:
                return .code
        }
    }
}
