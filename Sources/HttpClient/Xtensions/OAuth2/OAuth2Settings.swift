//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.12.2022.
//

import Foundation

public struct OAuth2Settings {
	let baseURL: URL
	let authorizationEndpoint : String
	let tokenEndpoint: String
	let redirectURL: URL
	let clientID: String
	let clientSecret: String
	let scope: String

	public init(
		baseURL: URL,
		authorizationEndpoint: String,
		tokenEndpoint: String,
		redirectURL: URL,
		clientID: String,
		clientSecret: String,
		scope: String
	) {
		self.baseURL = baseURL
		self.authorizationEndpoint = authorizationEndpoint
		self.tokenEndpoint = tokenEndpoint
		self.redirectURL = redirectURL
		self.clientID = clientID
		self.clientSecret = clientSecret
		self.scope = scope
	}
}
