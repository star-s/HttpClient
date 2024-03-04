//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension HttpStatusCode {

    static let `continue`: HttpStatusCode                   = 100
    static let switchingProtocols: HttpStatusCode           = 101

    static let ok: HttpStatusCode                           = 200
    static let created: HttpStatusCode                      = 201
    static let accepted: HttpStatusCode                     = 202
    static let nonAuthoritativeInformation: HttpStatusCode  = 203
    static let noContent: HttpStatusCode                    = 204
    static let resetContent: HttpStatusCode                 = 205
    static let partialContent: HttpStatusCode               = 206

    static let multipleChoices: HttpStatusCode              = 300
    static let movedPermanently: HttpStatusCode             = 301
    static let found: HttpStatusCode                        = 302
    static let seeOther: HttpStatusCode                     = 303
    static let notModified: HttpStatusCode                  = 304
    static let useProxy: HttpStatusCode                     = 305
    static let unused: HttpStatusCode                       = 306
    static let temporaryRedirect: HttpStatusCode            = 307

    static let badRequest: HttpStatusCode                   = 400
    static let unauthorized: HttpStatusCode                 = 401
    static let paymentRequired: HttpStatusCode              = 402
    static let forbidden: HttpStatusCode                    = 403
    static let notFound: HttpStatusCode                     = 404
    static let methodNotAllowed: HttpStatusCode             = 405
    static let notAcceptable: HttpStatusCode                = 406
    static let proxyAuthenticationRequired: HttpStatusCode  = 407
    static let requestTimeout: HttpStatusCode               = 408
    static let conflict: HttpStatusCode                     = 409
    static let gone: HttpStatusCode                         = 410
    static let lengthRequired: HttpStatusCode               = 411
    static let preconditionFailed: HttpStatusCode           = 412
    static let requestEntityTooLarge: HttpStatusCode        = 413
    static let requestURITooLong: HttpStatusCode            = 414
    static let unsupportedMediaType: HttpStatusCode         = 415
    static let requestedRangeNotSatisfiable: HttpStatusCode = 416
    static let expectationFailed: HttpStatusCode            = 417

    static let internalServerError: HttpStatusCode          = 500
    static let notImplemented: HttpStatusCode               = 501
    static let badGateway: HttpStatusCode                   = 502
    static let serviceUnavailable: HttpStatusCode           = 503
    static let gatewayTimeout: HttpStatusCode               = 504
    static let httpVersionNotSupported: HttpStatusCode      = 505
}
