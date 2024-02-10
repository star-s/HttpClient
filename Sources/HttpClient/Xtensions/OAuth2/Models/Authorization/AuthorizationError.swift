//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation

/// https://www.rfc-editor.org/rfc/rfc6749#section-4.2.2.1
public struct AuthorizationError: Error, Decodable {
	public enum ErrorType: String, Decodable {
		case invalidRequest = "invalid_request"
		case unauthorizedClient = "unauthorized_client"
		case accessDenied = "access_denied"
		case unsupportedResponseType = "unsupported_response_type"
		case invalidScope = "invalid_scope"
		case serverError = "server_error"
		case temporarilyUnavailable = "temporarily_unavailable"
	}

	private enum CodingKeys: String, CodingKey {
		case error
		case errorDescription = "error_description"
		case errorURI = "error_uri"
	}

	public let error: ErrorType
	public let errorDescription: String?
	public let errorURI: URL?
}
