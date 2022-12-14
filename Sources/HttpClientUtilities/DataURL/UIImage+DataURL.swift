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
			$0.tag(as: kUTTypePNG).dataUrlBuilder(encoding: .base64)
		}
	}

	public func jpeg(quality: CGFloat = 1.0) -> DataUrlBuilder? {
		jpegData(compressionQuality: quality).map {
			$0.tag(as: kUTTypeJPEG).dataUrlBuilder(encoding: .base64)
		}
	}
}

#endif
