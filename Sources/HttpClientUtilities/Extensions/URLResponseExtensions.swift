//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import CoreServices

public extension URLResponse {
	
	var textEncoding: String.Encoding? {
		(textEncodingName as CFString?).map {
			String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding($0)))
		}
	}
	
	var contentUTI: CFString? {
		(mimeType as CFString?).flatMap {
			UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, $0, nil)?.takeRetainedValue()
		}
	}

	var tags: Set<TaggedData.Tag> {
		var tags = Set<TaggedData.Tag>()
		if let mimeType = mimeType {
			tags.insert(.mimeType(mimeType))
		}
		if let textEncoding = textEncoding {
			tags.insert(.textEncoding(textEncoding))
		}
		return tags
	}

	func checkStatusCode<R: RangeExpression>(valid range: R) throws where R.Bound == Int {
		guard let httpResponse = self as? HTTPURLResponse else {
			return
		}
		guard range.contains(httpResponse.statusCode) else {
			throw httpResponse
		}
	}
}
