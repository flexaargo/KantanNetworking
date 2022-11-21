//
//  RemoteConfiguration.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

import Foundation

/// Used to configure a `RemoteClient`.
public struct RemoteConfiguration {
  public private(set) var decoder: JSONDecoder = JSONDecoder()

  public init() { }

  public init(decoder: JSONDecoder) {
    self.decoder = decoder
  }

  public init(decoder: () -> JSONDecoder) {
    self.decoder = decoder()
  }
}