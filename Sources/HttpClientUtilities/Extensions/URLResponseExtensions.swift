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
}
