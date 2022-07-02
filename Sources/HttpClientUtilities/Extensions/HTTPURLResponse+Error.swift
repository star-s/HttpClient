//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 02.07.2022.
//

import Foundation

extension HTTPURLResponse: LocalizedError {
	public var errorDescription: String? {
		Self.localizedString(forStatusCode: statusCode)
	}
}
