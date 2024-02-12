//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.02.2024.
//

import Foundation

struct RequestWithAdditionalParameters<R, P> {
    let request: R
    let parameters: P

    init(_ request: R, _ parameters: P) {
        self.request = request
        self.parameters = parameters
    }
}

extension RequestWithAdditionalParameters: Encodable where R: Encodable, P: Encodable {
    func encode(to encoder: Encoder) throws {
        try request.encode(to: encoder)
        try parameters.encode(to: encoder)
    }
}
