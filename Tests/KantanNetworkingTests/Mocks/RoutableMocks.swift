//
//  RoutableMocks.swift
//  KantanNetworkingTests
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation
import KantanNetworking

enum RoutableMocks: Routable {
  case endpoint1
  case endpoint2(id: String, name: String, age: Int)
  case badEndpoint
  
  var baseUrl: String {
    "some.website.com"
  }
  
  var method: HTTPMethod {
    switch self {
    case .endpoint1, .badEndpoint:
      return .get
    case .endpoint2:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .endpoint1:
      return "/path/to/endpoint/1"
    case .endpoint2:
      return "/path/to/endpoint/2"
    case .badEndpoint:
      return "badEndpoint"
    }
  }
  
  var parameters: HTTPParameters {
    switch self {
    case .endpoint1, .badEndpoint:
      return [:]
    case .endpoint2(let id, _, _):
      return ["id": id]
    }
  }
  
  var body: HTTPBody? {
    switch self {
    case .endpoint1, .badEndpoint:
      return nil
    case .endpoint2(_, let name, let age):
      return ["name": name, "age": age, "object": ["test": 10]]
    }
  }
  
  var headers: HTTPHeaders? {
    switch self {
    case .endpoint1, .badEndpoint:
      return nil
    case .endpoint2:
      return ["Bearer": "someToken"]
    }
  }
  
  var contentType: HTTPContentType {
    switch self {
    case .endpoint1, .badEndpoint:
      return .none
    case .endpoint2:
      return .json
    }
  }
}
