//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.02.2024.
//

import Foundation

enum OAuth2ClientError: Error {
    case wrongRedirectURL
    case stateMismatch
}
