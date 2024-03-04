//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension HttpStatusCode {

    var isInformational: Bool {
        Set<HttpStatusCode>.informational.contains(self)
    }

    var isSuccessful: Bool {
        Set<HttpStatusCode>.successful.contains(self)
    }

    var isRedirection: Bool {
        Set<HttpStatusCode>.redirection.contains(self)
    }

    var isClientError: Bool {
        Set<HttpStatusCode>.clientError.contains(self)
    }

    var isServerError: Bool {
        Set<HttpStatusCode>.serverError.contains(self)
    }
}

public extension Set where Element == HttpStatusCode {

    static let informational: Set<HttpStatusCode> = [
        .continue,
        .switchingProtocols,
    ]

    static let successful: Set<HttpStatusCode> = [
        .ok,
        .created,
        .accepted,
        .nonAuthoritativeInformation,
        .noContent,
        .resetContent,
        .partialContent,
    ]

    static let redirection: Set<HttpStatusCode> = [
        .multipleChoices,
        .movedPermanently,
        .found,
        .seeOther,
        .notModified,
        .useProxy,
        .unused,
        .temporaryRedirect,
    ]

    static let clientError: Set<HttpStatusCode> = [
        .badRequest,
        .unauthorized,
        .paymentRequired,
        .forbidden,
        .notFound,
        .methodNotAllowed,
        .notAcceptable,
        .proxyAuthenticationRequired,
        .requestTimeout,
        .conflict,
        .gone,
        .lengthRequired,
        .preconditionFailed,
        .requestEntityTooLarge,
        .requestURITooLong,
        .unsupportedMediaType,
        .requestedRangeNotSatisfiable,
        .expectationFailed,
    ]

    static let serverError: Set<HttpStatusCode> = [
        .internalServerError,
        .notImplemented,
        .badGateway,
        .serviceUnavailable,
        .gatewayTimeout,
        .httpVersionNotSupported,
    ]
}
