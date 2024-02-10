//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 31.12.2022.
//

import Foundation

public protocol OAuth2Client: HttpClient {

    var authorizationEndpoint: Path { get }
    var tokenEndpoint: Path { get }

    var redirectURL: URL { get }

    var clientID: String { get }

    var scope: String { get }
}
