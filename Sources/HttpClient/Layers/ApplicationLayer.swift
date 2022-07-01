//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public protocol ApplicationLayer {
    associatedtype Path
	
	func post<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T
}
