//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

public extension RequestEncoder {
    
    func withRequestTuner(_ tuner: @escaping (inout URLRequest) -> Void) -> TunableRequestEncoder<Self> {
        TunableRequestEncoder(self, tuner: tuner)
    }

    func eraseToAnyRequestEncoder() -> AnyRequestEncoder {
        AnyRequestEncoder(self)
    }
}
