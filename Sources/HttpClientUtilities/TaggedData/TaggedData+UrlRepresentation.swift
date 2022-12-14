//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.12.2022.
//

import Foundation
import CoreServices

extension TaggedData {
	public func urlRepresentation(encoding: DataUrlEncoding = .base64) -> URL? {
		guard let mimeType = mimeType else {
			return nil
		}
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
