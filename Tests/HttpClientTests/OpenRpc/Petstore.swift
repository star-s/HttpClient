//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation

// https://raw.githubusercontent.com/open-rpc/examples/master/service-descriptions/petstore-openrpc.json

protocol PetstoreApi {
}

extension OpenRpc: PetstoreApi {}
