//
//  APIClient.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

#if(os(iOS))

import Foundation
import Combine
import SwiftUI

open class APIClient: RemoteClient {
  var configuration: RemoteConfiguration

  var urlSession: URLSession
  var decoder: JSONDecoder

  var localCancellables: Set<AnyCancellable> = Set()

  required public init(configuration: RemoteConfiguration = RemoteConfiguration()) {
    self.configuration = configuration

    let sessionConfig: URLSessionConfiguration = .default
    urlSession = URLSession(configuration: sessionConfig)

    decoder = configuration.decoder
  }

  /// Creates `URLComponents` from a given routable. The scheme used is HTTPS.
  ///
  /// Configuration:
  /// - `routable.baseUrl` as the `host`
  /// - `routable.path` as the `path`
  /// - `routable.parameters` as the `queryItems`
  /// - `scheme` is "https"
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  /// - Returns: `URLComponents` composed out of the information in routable
  public func makeUrlComponents(from routable: Routable) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.host = routable.baseUrl
    urlComponents.scheme = "https"
    urlComponents.path = routable.path
    let queryItems = routable.parameters.compactMap { key, value in URLQueryItem(name: key, value: "\(value)") }
    urlComponents.queryItems = queryItems.count > 0 ? queryItems : nil
    return urlComponents
  }

  /// Creates a `URL` from a given routable by getting the URL from `makeUrlComponents(from:)`.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  /// - Throws: `KantanError.makeUrl(reason:)` if the `URL` from `URLComponents` is nil.
  /// - Returns: `URL` made from `makeUrlComponents(from:)` returned `URLComponents`.
  public func makeUrl(from routable: Routable) throws -> URL {
    guard let url = makeUrlComponents(from: routable).url else {
      throw KantanError.makeUrl(reason: "URL from components is nil.")
    }
    return url
  }

  /// Creates a `URLRequest` from a given routable with a `URL` from `makeUrl(from:)`. Also configures the header
  /// with the `Routable` headers and Content-Type as well as the body with the `Routable` body as `Data`.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  /// - Throws: `KantanError.makeUrlComponents(reason:)` if `makeUrl(from:)` throws an error.
  /// - Returns: `URLRequest` made from `makeUrl(from:)` returned `URL`.
  public func makeUrlRequest(from routable: Routable) throws -> URLRequest {
    do {
      let url = try makeUrl(from: routable)
      var request = URLRequest(url: url)
      request.allHTTPHeaderFields = routable.headers ?? [:]
      if routable.contentType != .none {
        request.allHTTPHeaderFields?["Content-Type"] = routable.contentType.rawValue
      }
      request.httpBody = routable.body?.data()
      return request
    } catch KantanError.makeUrl(let reason) {
      throw KantanError.makeUrlRequest(reason: reason)
    }
  }

  // MARK: - Completions

  /// Makes a request for a `Routable` and will complete with a `Result` that is either a
  /// `Decodable` type or an `Error`. The `Decodable` type will be decoded from the response body.
  /// If the `Response` type is `Bool`, the `Bool` will represent success.
  /// If the `Response` type is `String`, the `String` will be a `utf8` representation of the body.
  /// - Parameters:
  ///   - routable: Contains information about the `URL` and `URLRequest`.
  ///   - completion: A closure that takes a `Result` as a parameter. Called upon network request
  ///   completion.
  public func request<Response>(for routable: Routable, completion: @escaping (Result<Response, Error>) -> Void) where Response: Decodable {
    requestPublisher(for: routable)
      .first()
      .sink(receiveCompletion: { result in
        switch result {
        case .failure(let error):
          completion(.failure(error))
        default: break
        }
      }, receiveValue: { (response: Response) in
        completion(.success(response))
      })
      .store(in: &localCancellables)
  }

  /// Makes a request for a `Routable` and will complete with a `Result` that is either a `UIImage`
  /// type or an `Error`. The `UIImage` type will be created from the data in the response body.
  /// - Parameters:
  ///   - routable: Contains information about the `URL` and `URLRequest`.
  ///   - completion: A closure that takes a `Result` as a parameter. Called upon network request
  ///   completion.
  public func requestImage(for routable: Routable, completion: @escaping (Result<UIImage, Error>) -> Void) {
    requestImagePublisher(for: routable)
      .first()
      .sink(receiveCompletion: { result in
        switch result {
        case .failure(let error):
          completion(.failure(error))
        default: break
        }
      }, receiveValue: { (image: UIImage) in
        completion(.success(image))
      })
      .store(in: &localCancellables)
  }

  // MARK: - Publishers

  /// Makes a `Publisher` that will emit either a `Response` decoded from the response body data or
  /// an `Error`.
  /// If the `Response` type is `Bool`, the `Bool` will represent success.
  /// If the `Response` type is `String`, the `String` will be a `utf8` representation of the body.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  public func requestPublisher<Response>(for routable: Routable) -> AnyPublisher<Response, Error> where Response: Decodable {
    requestInternal(for: routable)
  }

  /// Makes a `Publisher` that will emit either a `UIImage` created from the response body data or
  /// an `Error`.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  public func requestImagePublisher(for routable: Routable) -> AnyPublisher<UIImage, Error> {
    requestInternal(for: routable)
  }
}

#endif