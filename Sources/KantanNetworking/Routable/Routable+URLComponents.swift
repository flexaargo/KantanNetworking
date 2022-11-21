//
//  Routable+URLComponents.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

extension Routable {
  func makeUrlComponents() -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.host = baseUrl
    urlComponents.scheme = "https"
    urlComponents.path = path
    let queryItems = parameters.compactMap { key, value in URLQueryItem(name: key, value: "\(value)") }
    urlComponents.queryItems = queryItems.count > 0 ? queryItems : nil
    return urlComponents
  }

  func makeUrl() -> URL? {
    let urlComponents = makeUrlComponents()
    return urlComponents.url
  }

  func makeUrlRequest() -> URLRequest? {
    guard let url = makeUrl() else { return nil }
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers ?? [:]
    if contentType != .none {
      request.allHTTPHeaderFields?["Content-Type"] = contentType.rawValue
    }
    request.httpBody = body?.data()

    return request
  }
}