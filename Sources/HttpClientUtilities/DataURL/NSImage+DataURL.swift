//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.07.2022.
//

import Foundation
import CoreServices
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSImage {
	
	public func png() -> DataUrlBuilder? {
		bitmapRep?.representation(using: .png, properties: [:]).map {
			$0.tag(as: kUTTypePNG).dataUrlBuilder(encoding: .base64)
		}
	}

	public func jpeg(quality: Float = 1.0) -> DataUrlBuilder? {
		bitmapRep?.representation(using: .jpeg, properties: [.compressionFactor: quality]).map {
			$0.tag(as: kUTTypeJPEG).dataUrlBuilder(encoding: .base64)
		}
	}

	private var bitmapRep: NSBitmapImageRep? {
		cgImage(forProposedRect: nil, context: nil, hints: nil).map {
			NSBitmapImageRep(cgImage: $0)
		}
	}
}

#endif
