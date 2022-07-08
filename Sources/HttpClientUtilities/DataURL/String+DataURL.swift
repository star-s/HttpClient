//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.07.2022.
//

import Foundation
import CoreServices

extension String {
	public func plainText(encoding: Encoding = .utf8) -> DataUrlBuilder? {
		data(using: encoding).map {
			DataUrlBuilder(kUTTypePlainText, data: $0, encoding: .charset(encoding))
		}
	}

	public func json() -> DataUrlBuilder? {
		data(using: .utf8).map {
			DataUrlBuilder(kUTTypeJSON, data: $0, encoding: .base64)
		}
	}
}
