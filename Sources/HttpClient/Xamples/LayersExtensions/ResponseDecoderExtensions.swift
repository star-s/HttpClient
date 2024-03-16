//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

public extension ResponseDecoder {

    func eraseToAnyResponseDecoder() -> AnyResponseDecoder {
        AnyResponseDecoder(self)
    }
}
