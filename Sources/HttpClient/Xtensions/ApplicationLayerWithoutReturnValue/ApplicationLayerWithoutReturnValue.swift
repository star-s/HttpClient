//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol ApplicationLayerWithoutReturnValue {
	associatedtype Path

	func post<P: Encodable>(_ path: Path, parameters: P) async throws
	func get<P: Encodable>(_ path: Path, parameters: P) async throws
	func put<P: Encodable>(_ path: Path, parameters: P) async throws
	func patch<P: Encodable>(_ path: Path, parameters: P) async throws
	func delete<P: Encodable>(_ path: Path, parameters: P) async throws
}
