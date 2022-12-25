//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 25.12.2022.
//

import Foundation

public extension DateFormatter {
	static let rfc3339: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		return dateFormatter
	}()

	static let rfc3339Nano: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		return dateFormatter
	}()
}
