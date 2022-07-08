//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.07.2022.
//

import Foundation

/// Based on code from https://github.com/Alamofire/Alamofire/blob/master/Source/Request.swift
extension URLRequest {
	/// cURL representation of the instance.
	///
	/// - Returns: The cURL equivalent of the instance.
	public func cURLDescription(sessionConfiguration: URLSessionConfiguration? = nil) -> String {
		guard
			let url = url,
			let host = url.host,
			let method = httpMethod else { return "$ curl command could not be created" }

		var components = ["$ curl -v"]

		components.append("-X \(method)")

		if let credentialStorage = sessionConfiguration?.urlCredentialStorage {
			let protectionSpace = URLProtectionSpace(host: host,
													 port: url.port ?? 0,
													 protocol: url.scheme,
													 realm: host,
													 authenticationMethod: NSURLAuthenticationMethodHTTPBasic)

			if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
				for credential in credentials {
					guard let user = credential.user, let password = credential.password else { continue }
					components.append("-u \(user):\(password)")
				}
			}
		}

		if let configuration = sessionConfiguration, configuration.httpShouldSetCookies {
			if
				let cookieStorage = configuration.httpCookieStorage,
				let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty {
				let allCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ";")

				components.append("-b \"\(allCookies)\"")
			}
		}

		var headers = HTTPHeaders()

		if let sessionHeaders = sessionConfiguration?.headers {
			for header in sessionHeaders where header.name != "Cookie" {
				headers[header.name] = header.value
			}
		}

		for header in self.headers where header.name != "Cookie" {
			headers[header.name] = header.value
		}

		for header in headers {
			let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
			components.append("-H \"\(header.name): \(escapedValue)\"")
		}

		if let httpBodyData = httpBody {
			let httpBody = String(decoding: httpBodyData, as: UTF8.self)
			var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
			escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

			components.append("-d \"\(escapedBody)\"")
		}

		components.append("\"\(url.absoluteString)\"")

		return components.joined(separator: " \\\n\t")
	}
}
