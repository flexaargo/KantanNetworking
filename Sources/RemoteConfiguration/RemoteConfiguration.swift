//
//  RemoteConfiguration.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/29/22
//

import Foundation

/// Used to configure a `RemoteClient`.
public protocol RemoteConfiguration {
    /// A host for a `URL`.
    var host: String { get }

    /// Any header values to apply to an HTTP request.
    var defaultHeaders: HTTPHeaders? { get }

    /// A JSON decoder used to decode `Data`.
    var decoder: JSONDecoder { get }
}
