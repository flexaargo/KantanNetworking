//
//  RemoteClient+URL.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

public extension RemoteClient {

  func createURL(from route: Routable) throws -> URL {
    var urlComponents = route.urlComponents()
    urlComponents.host = configuration.host
    guard let url = urlComponents.url else {
      throw KantanError.failedToCreateURL(route: route, host: configuration.host)
    }
    return url
  }

}

extension RemoteClient {

  /// Creates a `URLRequest` from the given `route`
  /// - Parameter route: The route to create a `URLRequest` from
  /// - Returns: A `URLRequest` instance
  func createURLRequest(from route: Routable) throws -> URLRequest {
    let url = try createURL(from: route)
    var request = URLRequest(url: url)
    request.httpMethod = route.method.rawValue
    route.headers?.forEach({ request.addValue($1, forHTTPHeaderField: $0) })
    request.httpBody = route.body
    return request
  }

}
