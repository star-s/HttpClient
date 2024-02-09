//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.02.2022.
//

import Foundation
import HttpClientUtilities

public protocol RequestEncoderWithMultipartFormData: RequestEncoder {
	func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest
}

public extension RequestEncoderWithMultipartFormData {
	
	func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest {
		let formData = MultipartFormData()
		multipartFormData(formData)
		return try URLRequest(url: url).with(method: .post).with(body: formData)
	}
}
