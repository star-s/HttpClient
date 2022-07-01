//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.06.2022.
//

import Foundation
import CoreServices

public struct DataUrlBuilder {

	public let type: CFString
	public let data: Data
	public let encoding: DataUrlEncoding

	public init(_ uti: CFString, data: Data, encoding: DataUrlEncoding = .base64) {
		self.type = uti
		self.data = data
		self.encoding = encoding
	}

	public func dataURL() -> URL? {
		data.urlRepresentation(mimeType: type, encoding: encoding)
	}
}

extension DataUrlBuilder: Equatable {
	public static func == (lhs: DataUrlBuilder, rhs: DataUrlBuilder) -> Bool {
		UTTypeEqual(lhs.type, rhs.type) && lhs.data == rhs.data
	}
}
