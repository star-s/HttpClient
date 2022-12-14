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
			$0.tag(as: kUTTypePlainText).dataUrlBuilder(encoding: .charset(encoding))
		}
	}

	public func json() -> DataUrlBuilder? {
		data(using: .utf8).map {
			$0.tag(as: kUTTypeJSON).dataUrlBuilder(encoding: .base64)
		}
	}
}
