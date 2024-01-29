//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.07.2022.
//

import Foundation

/// Example - for debug purposes only !!!
public struct DefaultTransportLoggerFactory: TransportLoggerFactory {
	private let sessionConfiguration: URLSessionConfiguration?

	public init(sessionConfiguration: URLSessionConfiguration? = nil) {
		self.sessionConfiguration = sessionConfiguration
	}

	public func makeLogger() -> TransportLogger {
		DefaultLogger(sessionConfiguration: sessionConfiguration)
	}
}

/// For debug purposes only !!!
/// Based on code from https://github.com/konkab/AlamofireNetworkActivityLogger/blob/master/Source/NetworkActivityLogger.swift
public final class DefaultLogger: TransportLogger {

	private let sessionConfiguration: URLSessionConfiguration?
	private var request: URLRequest?
	private var startDate: Date?

	public init(sessionConfiguration: URLSessionConfiguration? = nil) {
		self.sessionConfiguration = sessionConfiguration
	}

	public func log(request: URLRequest) {
		startDate = Date()

		guard let httpMethod = request.httpMethod,
			let requestURL = request.url
			else {
				return
		}
		let cURL = request.cURLDescription(sessionConfiguration: sessionConfiguration)

		self.logDivider()

		print("\(httpMethod) '\(requestURL.absoluteString)':")

		print("cURL:\n\(cURL)\n")

		self.request = request
	}

	public func log(result: Result<(data: Data, response: URLResponse), Error>) {
		guard let taskInterval = startDate.map({ DateInterval(start: $0, end: Date()) }), let request = request else {
			return
		}
		switch result {
		case .success(let response):
			log(response: response, of: request, taskInterval: taskInterval)
		case .failure(let error):
			log(error: error, of: request, taskInterval: taskInterval)
		}
		self.request = nil
	}

	// MARK: - Internal stuff

	private func log(response: (data: Data, response: URLResponse), of request: URLRequest, taskInterval: DateInterval) {
		guard let requestURL = response.response.url else {
			return
		}
		let data = response.data

		guard let response = response.response as? HTTPURLResponse else {
			return
		}
		self.logDivider()

		let elapsedTime = taskInterval.duration

		print("\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")

		self.logHeaders(headers: response.allHeaderFields)

		print("Body:")

		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
			let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

			if let prettyString = String(data: prettyData, encoding: .utf8) {
				print(prettyString)
			}
		} catch {
			if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
				print(string)
			}
		}
		print("")
	}

	private func log(error: Error, of request: URLRequest, taskInterval: DateInterval) {
		guard let httpMethod = request.httpMethod,
			let requestURL = request.url
			else {
				return
		}
		let elapsedTime = taskInterval.duration

		print("[Error] \(httpMethod) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
		print(error)
	}

	private func logDivider() {
		print("---------------------")
	}

	private func logHeaders(headers: [AnyHashable : Any]) {
		print("Headers: [")
		for (key, value) in headers {
			print("  \(key): \(value)")
		}
		print("]")
	}
}
