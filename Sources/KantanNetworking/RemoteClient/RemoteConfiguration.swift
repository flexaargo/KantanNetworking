//
//  RemoteConfiguration.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

/// Used to configure a `RemoteClient`.
public struct RemoteConfiguration {

  /// A host for a `URL`.
  public var host: String
  /// Any header values to apply to an HTTP request.
  public var defaultHeaders: HTTPHeaders?
  /// A JSON decoder used to decode `Data`.
  public var decoder: JSONDecoder

  public init(host: String, defaultHeaders: HTTPHeaders? = nil, decoder: JSONDecoder = JSONDecoder()) {
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