//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public protocol Credentials {
    func authorize(headers: HTTPHeaders) throws -> HTTPHeaders
}
