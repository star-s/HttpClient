//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.02.2022.
//

import Foundation

extension URLRequest {
	
	func encodingBody(with multipartFormData: MultipartFormData, encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold) throws -> URLRequest {
		var request = self
		if multipartFormData.contentLength < encodingMemoryThreshold {
			request.httpBody = try multipartFormData.encode()
		} else {
			let tempDirectoryURL = multipartFormData.fileManager.temporaryDirectory
			let directoryURL = tempDirectoryURL.appendingPathComponent("org.httpclient.manager/multipart.form.data")
			let fileName = UUID().uuidString
			let fileURL = directoryURL.appendingPathComponent(fileName)

			try multipartFormData.fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)

			do {
				try multipartFormData.writeEncodedData(to: fileURL)
				let stream = InputStream(url: fileURL)
				stream?.fileCleaner = .init(url: fileURL, manager: multipartFormData.fileManager)
				request.httpBodyStream = stream
			} catch {
				// Cleanup after attempted write if it fails.
				try? multipartFormData.fileManager.removeItem(at: fileURL)
				throw error
			}
		}
		request.headers.add(.contentType(multipartFormData.contentType))
		return request
	}
}

private extension InputStream {
	final class FileCleaner {
		private let url: URL
		private let manager: FileManager

		init(url: URL, manager: FileManager = .default) {
			assert(url.isFileURL)
			self.url = url
			self.manager = manager
		}

		deinit {
			try? manager.removeItem(at: url)
		}
	}

	private struct AssociateKeys {
		static var file: Void?
	}

	var fileCleaner: FileCleaner? {
		get {
			objc_getAssociatedObject(self, &AssociateKeys.file) as? FileCleaner
		}
		set {
			objc_setAssociatedObject(self, &AssociateKeys.file, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
}
