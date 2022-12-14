//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.12.2022.
//

import Foundation
import Combine
import URLEncodedForm

extension URLEncodedFormDecoder: TopLevelDecoder {}
extension PlaintextDecoder: TopLevelDecoder {}
extension DataOnlyDecoder: TopLevelDecoder {}
