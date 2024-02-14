//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.02.2024.
//

#if canImport(AuthenticationServices)
import AuthenticationServices

final public class DefaultPresentationContextProvider: NSObject {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        #if os(iOS)
        return UIApplication
            .shared
            .connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow }) ?? ASPresentationAnchor()
        #elseif os(macOS)
        return NSApplication
            .shared
            .keyWindow ?? ASPresentationAnchor()
        #endif
    }
}
#endif
