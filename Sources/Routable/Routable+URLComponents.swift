//
//  Routable+URLComponents.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

extension Routable {

  /// Creates `URLComponents` from its properties.
  ///
  /// Configures the URLComponents with:
  ///   - `URLComponents.scheme` set to `"https"`
  ///   - `URLComponents.path` set to `path` if not `nil`
  ///   - `URLComponents.queryItems` set to `parameters`
  ///
  /// - Returns: An instance of `URLComponents`
  func urlComponents() -> URLComponents {
    var urlComponents = URLComponents()
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
    parameters?.map({ URLQueryItem(name: $0, value: $1) })
  }

}
