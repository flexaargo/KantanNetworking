//
//  Routable+URLComponents.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

public extension Routable {
    /// Creates `URLComponents` from its properties.
    ///
    /// Configures the URLComponents with:
    ///   - `URLComponents.scheme` set to `"https"`
    ///   - `URLComponents.path` set to `path` if not `nil`
    ///   - `URLComponents.queryItems` set to `parameters`
    ///
    /// - Parameters:
    ///   - host: The host component to use for the `URLComponents`
    /// - Returns: An instance of `URLComponents`
    func urlComponents(withHost host: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = "https"
        if let path { urlComponents.path = path }
        urlComponents.queryItems = queryItems()
        return urlComponents
    }
}

private extension Routable {
    /// Creates an array of `URLQueryItem` from its parameters.
    /// - Returns: An array of `URLQueryItem` or `nil` if no parameters.
    func queryItems() -> [URLQueryItem]? {
        parameters?.map { URLQueryItem(name: $0, value: $1) }
    }
}
