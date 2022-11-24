//
//  Routable.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/8/20.
//
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias HTTPBody = Data
public typealias HTTPParameters = [String: String]

/// HTTP request methods
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol Routable {
    /// The method to use for the request for this route
    var method: HTTPMethod { get }
    /// The path to use for the URL for this route.
    var path: String? { get }
    /// Any parameters to put inside the URL for this route.
    var parameters: HTTPParameters? { get }
    /// Any body data associated with this route.
    var body: HTTPBody? { get }
    /// Any headers associated with this route.
    var headers: HTTPHeaders? { get }
}

public extension Routable {
    /// Default to nil.
    var parameters: HTTPParameters? { nil }
    /// Default to nil.
    var body: HTTPBody? { nil }
    /// Default to nil.
    var headers: HTTPHeaders? { nil }
}
