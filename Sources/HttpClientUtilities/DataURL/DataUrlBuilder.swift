//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.06.2022.
//

import Foundation
import CoreServices

public struct DataUrlBuilder {

	let data: TaggedData
	let encoding: DataUrlEncoding

	public init(_ uti: CFString, data: Data, encoding: DataUrlEncoding = .base64) {
		self.data = data.tag(by: uti)
		self.encoding = encoding
	}

	public func dataURL() -> URL? {
		data.urlRepresentation(encoding: encoding)
	}
}
