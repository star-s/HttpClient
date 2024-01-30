//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public protocol PresentationLayer {
    
    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest
    
	func validate(response: (data: Data, response: URLResponse)) async throws
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T
}
