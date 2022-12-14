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

public enum DataUrlEncoding {
	case base64
	case charset(String.Encoding)
}

public extension Data {
	func urlRepresentation(mimeType uti: CFString = kUTTypeData, encoding: DataUrlEncoding = .base64) -> URL? {
		tag(as: uti).urlRepresentation(encoding: encoding)
	}
}

extension DataUrlEncoding: CustomStringConvertible {
	public var description: String {
		switch self {
		case .base64:
			return ";base64"
		case .charset(let encoding):
			return encoding.IANACharSetName.map { ";charset=\($0)" } ?? ""
		}
	}
}
