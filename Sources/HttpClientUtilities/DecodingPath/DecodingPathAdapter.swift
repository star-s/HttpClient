//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.02.2021.
//

import Foundation

public struct DecodingPathAdapter<T: Decodable>: Decodable {
    public let payload: T
    
    public init(from decoder: Decoder) throws {
        payload = try decoder.decode(T.self, byDecodingPath: decoder.valueDecodingPath)
    }
}
