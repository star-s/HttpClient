//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.02.2024.
//

#if os(iOS)
import AuthenticationServices

extension UIApplication: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow }) ?? ASPresentationAnchor()
    }
}
#endif

#if os(macOS)
import AuthenticationServices

extension NSApplication: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        keyWindow ?? ASPresentationAnchor()
    }
}
#endif
