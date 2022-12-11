//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

public enum ResponseType: String, Encodable {
	case code
	case token
}

struct AuthorizationRequest: Encodable {
	private enum CodingKeys: String, CodingKey {
		case type = "response_type"
		case clientID = "client_id"
		case scope
		case state
		case redirectURL = "redirect_uri"
	}

	let type: ResponseType
	let clientID: String
	let scope: String?
	let state: String?
	let redirectURL: URL?
}
