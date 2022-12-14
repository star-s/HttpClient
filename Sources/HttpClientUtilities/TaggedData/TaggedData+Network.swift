//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.12.2022.
//

import Foundation

public extension URLResponse {
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
}

public extension URLRequest {
	func with(body taggedData: TaggedData) -> URLRequest {
		var request = self
		request.httpBody = taggedData.data
		guard let mimeType = taggedData.mimeType else {
			return request
		}
		if let charset = taggedData.textEncoding?.IANACharSetName {
			request.headers.update(.contentType(mimeType + "; charset=\(charset)"))
		} else {
			request.headers.update(.contentType(mimeType))
		}
		return request
	}
}
