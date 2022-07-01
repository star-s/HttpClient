//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.06.2022.
//

import Foundation
import CoreServices

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

extension Data {

	public func urlRepresentation(mimeType uti: CFString = kUTTypeData, encoding: DataUrlEncoding = .base64) -> URL? {
		guard let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() else {
			return nil
		}
		guard let data = encodeToString(encoding) else {
			return nil
		}
		return URL(string: "data:\(mimeType)\(encoding),\(data)")
	}

	private func encodeToString(_ encodinng: DataUrlEncoding) -> String? {
		switch encodinng {
		case .base64:
			return base64EncodedString()
		case .charset(let encoding):
			return String(data: self, encoding: encoding)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		}
	}
}
