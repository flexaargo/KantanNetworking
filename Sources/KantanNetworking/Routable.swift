//
//  Routable.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/8/20.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias HTTPBody = [String: AnyHashable]
public typealias HTTPParameters = [String: AnyHashable]

public enum HTTPMethod: String {
  case get    = "GET"
  case post   = "POST"
  case put    = "PUT"
  case patch  = "PATCH"
  case delete = "DELETE"
}

public enum HTTPContentType: String {
  case json   = "application/json"
  case none   = ""
}

public protocol Routable {
  var baseUrl: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: HTTPParameters { get }
  var body: HTTPBody? { get }
  var headers: HTTPHeaders? { get }
  var contentType: HTTPContentType { get }
}

internal extension Routable {
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
