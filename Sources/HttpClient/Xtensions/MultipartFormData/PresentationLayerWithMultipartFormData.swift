//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.02.2022.
//

import Foundation

public protocol PresentationLayerWithMultipartFormData: PresentationLayer {
	func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest
}

public extension PresentationLayerWithMultipartFormData {
	
	func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest {
		try await withCheckedThrowingContinuation { continuation in
			let formData = MultipartFormData()
			multipartFormData(formData)
			continuation.resume(with: Result {
				try URLRequest(url: url).settingHeaders().settingMethod(.post).encodingBody(with: formData)
			})
		}
	}
}

public extension PresentationLayerWithMultipartFormData where Self: PresentationLayerWithCustomizations {
	
	func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest {
		try await withCheckedThrowingContinuation { [headers] continuation in
			let formData = MultipartFormData()
			multipartFormData(formData)
			continuation.resume(with: Result {
				try URLRequest(url: url).settingHeaders(headers).settingMethod(.post).encodingBody(with: formData)
			})
		}
	}
}
