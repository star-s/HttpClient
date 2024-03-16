//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import Combine
import HttpClientUtilities

public protocol CustomRequestEncoder: RequestEncoder {
    var defaultHeaders: HTTPHeaders { get }
    var requestAuthorizer: RequestAuthorizer? { get }

	associatedtype QueryEncoder: TopLevelEncoder = URLQueryEncoder where QueryEncoder.Output == String
	var queryEncoder: QueryEncoder { get }

	associatedtype BodyEncoder: TopLevelEncoder = JSONEncoder where BodyEncoder.Output == Data
	var bodyEncoder: BodyEncoder { get }
}
