//
//  KantanError.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation

public enum KantanError: Error, CustomStringConvertible {
  case unknown(reason: String? = nil)
  case makeUrl(reason: String? = nil)
  case makeUrlRequest(reason: String? = nil)
  case decoding(reason: String? = nil)
  case invalidResponse
  case invalidStatus(statusCode: Int)
  
  public var description: String {
    var description: String = "[KANTAN ERROR] "
    switch self {
    case .unknown(let reason):
      description.append("Unknown \(reason != nil ? reason ?? "" : "")")
    case .makeUrl(let reason):
      description.append("Could not make url. Reason: \(reason ?? "unspecified")")
    case .makeUrlRequest(let reason):
      description.append("Could not make url request. Reason: \(reason ?? "unspecified")")
    case .decoding(let reason):
      description.append("There was an error decoding the response. Reason: \(reason ?? "unspecified")")
    case .invalidResponse:
      description.append("Received invalid response from server.")
    case .invalidStatus(let statusCode):
      description.append("Received invalid status code from server. Status code: \(statusCode)")
    }
    return description
  }
}
