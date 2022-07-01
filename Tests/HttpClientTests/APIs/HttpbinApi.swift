//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.02.2022.
//

import Foundation
import HttpClient

public protocol HttpbinApi: HttpClientWithBaseUrl where Path: PathExpressibleByInterpolation {
}

public extension HttpbinApi {
	var baseURL: URL { "https://httpbin.org" }
}

// MARK: - Public API

public extension HttpbinApi {
	
}
