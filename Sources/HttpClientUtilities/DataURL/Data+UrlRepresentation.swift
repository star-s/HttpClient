//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.06.2022.
//

import Foundation
import CoreServices

extension URL {
	/// Returns true if the scheme is `data:`.
	public var isDataURL: Bool {
		scheme == "data"
	}
}

public enum DataUrlEncoding: CustomStringConvertible {
	case base64
	case charset(String.Encoding)

	public var description: String {
		switch self {
		case .base64:
			return ";base64"
		case .charset(let encoding):
			return encoding.IANACharSetName.map { ";charset=\($0)" } ?? ""
		}
	}
}

public extension Data {
	func urlRepresentation(mimeType uti: CFString = kUTTypeData, encoding: DataUrlEncoding = .base64) -> URL? {
		tag(as: uti).urlRepresentation(encoding: encoding)
	}
}

extension TaggedData {
	public func urlRepresentation(encoding: DataUrlEncoding = .base64) -> URL? {
		guard let data = data.encodeToString(encoding) else {
			return nil
		}
		return URL(string: "data:\(mimeType)\(encoding),\(data)")
	}
}

private extension Data {
	func encodeToString(_ encodinng: DataUrlEncoding) -> String? {
		switch encodinng {
		case .base64:
			return base64EncodedString()
		case .charset(let encoding):
			return String(data: self, encoding: encoding)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		}
	}
}
