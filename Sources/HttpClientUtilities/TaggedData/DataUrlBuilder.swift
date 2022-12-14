//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.06.2022.
//

import Foundation

public struct DataUrlBuilder {
	fileprivate let data: TaggedData
	fileprivate let encoding: DataUrlEncoding

	public func dataURL() -> URL? {
		data.urlRepresentation(encoding: encoding)
	}
}

public extension TaggedData {
	func dataUrlBuilder(encoding: DataUrlEncoding = .base64) -> DataUrlBuilder {
		DataUrlBuilder(data: self, encoding: encoding)
	}
}
