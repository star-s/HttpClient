//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.07.2022.
//

import Foundation
import CoreServices
#if canImport(UIKit)
import UIKit

extension UIImage {
	public func png() -> DataUrlBuilder? {
		pngData().map {
			DataUrlBuilder(kUTTypePNG, data: $0, encoding: .base64)
		}
	}

	public func jpeg(quality: CGFloat = 1.0) -> DataUrlBuilder? {
		jpegData(compressionQuality: quality).map {
			DataUrlBuilder(kUTTypeJPEG, data: $0, encoding: .base64)
		}
	}
}

#endif
