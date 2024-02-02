//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation

struct OpenRpcDocument: Codable {
	struct Info: Codable {
		struct License: Codable {
			let name: String
			let url: URL
		}
		let title: String
		let version: String
		let description: String?
		let license: License?
	}

	struct Method: Codable {
		let name: String
		let summary: String
		let params: [Param]
		let result: Result
		let examples: [Example]
	}

	let openrpc: String
	let info: Info
	let methods: [Method]
}

extension OpenRpcDocument.Method {
	struct Param: Codable {
	}

	struct Result: Codable {
		struct Schema: Codable {
			let type: String
		}

		let name: String
		let schema: Schema
	}

	struct Example: Codable {
		struct Param: Codable {
		}

		struct Result: Codable {
			let name: String
			let value: Value
		}

		let name: String
		let params: [Param]
		let result: Result
	}
}

extension OpenRpcDocument.Method.Example.Result {
	enum Value {
		case string(String)
		case versions([Version])
	}
}

extension OpenRpcDocument.Method.Example.Result.Value: Codable {
	struct Version: Codable {
		let status: String
		let updated: String
		let id: String

		struct Url: Codable {
			let href: String
			let rel: String
		}
		let urls: [Url]
	}

	private enum CodingKeys: String, CodingKey {
		case versions
	}

	init(from decoder: Decoder) throws {
		if let container = try? decoder.container(keyedBy: CodingKeys.self) {
			self = try .versions(container.decode([Version].self, forKey: .versions))
			return
		}
		self = try .string(decoder.singleValueContainer().decode(String.self))
	}

	func encode(to encoder: Encoder) throws {
		switch self {
			case .string(let value):
				var container = encoder.singleValueContainer()
				try container.encode(value)
			case .versions(let values):
				var container = encoder.container(keyedBy: CodingKeys.self)
				try container.encode(values, forKey: .versions)
		}
	}
}
