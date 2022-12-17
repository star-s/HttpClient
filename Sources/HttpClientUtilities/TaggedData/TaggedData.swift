//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.12.2022.
//

import Foundation
import CoreServices

public struct TaggedData {
	public enum Tag {
		case mimeType(String)
		case textEncoding(String.Encoding)
	}

	public let data: Data
	fileprivate let tags: Set<Tag>
}

public extension TaggedData {
	var mimeType: String? { tags.mimeType }

	// charset
	var textEncoding: String.Encoding? { tags.textEncoding }

	func tagged(_ tag: TaggedData.Tag) -> TaggedData {
		var tags = self.tags
		tags.update(with: tag)
		return TaggedData(data: data, tags: tags)
	}
}

extension TaggedData.Tag: Hashable {
	public func hash(into hasher: inout Hasher) {
		switch self {
		case .mimeType:
			hasher.combine(0)
		case .textEncoding:
			hasher.combine(1)
		}
	}
}

public extension Data {
	func tagged(with tags: Set<TaggedData.Tag>) -> TaggedData {
		TaggedData(data: self, tags: tags)
	}

	func tagged(_ tag: TaggedData.Tag) -> TaggedData {
		TaggedData(data: self, tags: [tag])
	}

	func tag(as uti: CFString) -> TaggedData {
		let mimeType = (UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as NSString?) as String?
		return tagged(.mimeType(mimeType ?? "application/octet-stream"))
	}
}

extension Set where Element == TaggedData.Tag {
	var mimeType: String? {
		for tag in self {
			if case .mimeType(let mimeType) = tag {
				return mimeType.lowercased()
			}
		}
		return nil
	}

	var textEncoding: String.Encoding? {
		for tag in self {
			if case .textEncoding(let encoding) = tag {
				return encoding
			}
		}
		return nil
	}
}

import URLEncodedForm

extension TaggedData: LosslessDataConvertible {
	public static func convertFromData(_ data: Data) -> TaggedData {
		TaggedData(data: data, tags: [])
	}

	public func convertToData() -> Data {
		data
	}
}
