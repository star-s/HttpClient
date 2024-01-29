//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.02.2022.
//

import Foundation
import HttpClient

// MARK: - Interface

public protocol HttpbinApi {
}

public extension URL {
	static let httpbinBaseURL: URL = "https://httpbin.org"
}

// MARK: - Implementation

public extension HttpbinApi where Self: ApplicationLayer, Path: PathExpressibleByInterpolation {
}
