//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 31.12.2022.
//

import Foundation

public protocol OAuth2Client: HttpClient {

    var clientID: String { get }

    var callbackURL: URL { get }

    var authorizationEndpoint: Path { get }
    var tokenEndpoint: Path { get }

    var scope: String { get }
}
