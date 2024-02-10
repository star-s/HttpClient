//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 09.02.2024.
//

import Foundation

struct OAuth2Response<T, E: Error> {
    let result: Result<T, E>
}

extension OAuth2Response: Decodable where T: Decodable, E: Decodable {

    private enum CodingKeys: String, CodingKey {
        case error
    }

    init(from decoder: Decoder) throws {
        result = try decoder.container(keyedBy: CodingKeys.self).contains(.error) ?
            .failure(E.init(from: decoder)) :
            .success(T.init(from: decoder))
    }
}
