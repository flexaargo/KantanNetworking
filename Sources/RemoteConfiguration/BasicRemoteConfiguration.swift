//
//  BasicRemoteConfiguration.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

public struct BasicRemoteConfiguration: RemoteConfiguration {

    public var host: String

    public var defaultHeaders: HTTPHeaders?

    public var decoder: JSONDecoder

    public init(
        host: String,
        defaultHeaders: HTTPHeaders? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.host = host
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
    }

    public init(host: String, defaultHeaders: HTTPHeaders? = nil, decoder: () -> JSONDecoder) {
        self.host = host
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder()
    }
}
