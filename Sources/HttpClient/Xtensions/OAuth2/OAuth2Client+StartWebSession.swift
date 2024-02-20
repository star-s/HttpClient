//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

#if os(macOS) || os(iOS)
import Foundation
import AuthenticationServices
import HttpClientUtilities

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
            let response = try decodeAuthorizationCode(redirect: redirectURL, state: state)
            return try await accessToken(code: response.code)
        case .implicit:
            return try decodeAccessToken(redirect: redirectURL, state: state)
        }
    }
}
#endif
