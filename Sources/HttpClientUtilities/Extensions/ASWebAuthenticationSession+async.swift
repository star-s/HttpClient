//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.02.2024.
//

#if os(macOS) || os(iOS)
import AuthenticationServices

public extension ASWebAuthenticationSession {
    @MainActor
    class func start(
        with url: URL,
        callbackURL: URL,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding,
        ephemeralWebBrowser: Bool = true
    ) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let session = Self(url: url, callbackURLScheme: callbackURL.scheme) { url, error in
                do {
                    if let error = error {
                        throw error
                    }
                    guard let url = url else {
                        throw URLError(.badServerResponse)
                    }
                    continuation.resume(returning: url)
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
