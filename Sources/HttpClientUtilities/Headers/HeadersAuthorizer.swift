//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.02.2024.
//

import Foundation

public protocol HeadersAuthorizer {
    func authorize(headers: HTTPHeaders) async throws -> HTTPHeaders
}
