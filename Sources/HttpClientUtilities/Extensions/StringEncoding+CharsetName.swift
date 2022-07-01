//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.07.2022.
//

import Foundation

extension String.Encoding {
	public var IANACharSetName: String? {
		CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(rawValue)) as String?
	}
}
