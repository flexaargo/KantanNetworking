//
//  APIClient.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation
import Combine
import SwiftUI

open class APIClient: RemoteClient {
  private var configuration: RemoteConfiguration
  
  private var urlSession: URLSession
  private var decoder: JSONDecoder
  
  private var localCancellables: Set<AnyCancellable> = Set()
  
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

// MARK: - Internal UIImage Requests
internal extension APIClient {
  func requestInternal(for routable: Routable) -> AnyPublisher<UIImage, Error> {
    do {
      let request = try makeUrlRequest(from: routable)
      return requestInternal(withRequest: request)
    } catch let error as KantanError {
      return Fail(error: error).eraseToAnyPublisher()
    } catch {
      return Fail(error: KantanError.unknown()).eraseToAnyPublisher()
    }
  }
  
  func requestInternal(withURL url: URL) -> AnyPublisher<UIImage, Error> {
    let request = URLRequest(url: url)
    return requestInternal(withRequest: request)
  }
  
  func requestInternal(withRequest request: URLRequest) -> AnyPublisher<UIImage, Error> {
    dataTaskPublisher(withRequest: request)
      .tryMap { data -> UIImage in
        guard let image = UIImage(data: data) else {
          throw KantanError.decoding(reason: "Could not create UIImage.")
        }
        return image
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Internal Decodable Requests
internal extension APIClient {
  func requestInternal<Response>(for routable: Routable) -> AnyPublisher<Response, Error> where Response: Decodable {
    do {
      let request = try makeUrlRequest(from: routable)
      return requestInternal(withRequest: request)
    } catch let error as KantanError {
      return Fail(error: error).eraseToAnyPublisher()
    } catch {
      return Fail(error: KantanError.unknown()).eraseToAnyPublisher()
    }
  }
  
  func requestInternal<Response>(withURL url: URL) -> AnyPublisher<Response, Error> where Response: Decodable {
    let request = URLRequest(url: url)
    return requestInternal(withRequest: request)
  }
  
  func requestInternal<Response>(withRequest request: URLRequest) -> AnyPublisher<Response, Error> where Response: Decodable {
    dataTaskPublisher(withRequest: request)
      .tryMap { [weak self] data -> Response in
        switch Response.self {
        case is String.Type, is Optional<String>.Type:
          guard let result = String(data: data, encoding: .utf8) as? Response else {
            throw KantanError.decoding(reason: "Could not decode String.")
          }
          return result
        case is Bool.Type, is Optional<Bool>.Type:
          guard let result = true as? Response else {
            throw KantanError.decoding(reason: "Could not decode Bool.")
          }
          return result
        default:
          var result: Response?
          do {
            result = try self?.decoder.decode(Response.self, from: data)
          } catch {
            throw KantanError.decoding(reason: "Could not decode \(String(describing: Response.self)).")
          }
          guard let unwrappedResult = result else {
            // This shouldn't happen because self should never be nil.
            throw KantanError.unknown(reason: "self is nil.")
          }
          return unwrappedResult
        }
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Generic Data Task Publisher
private extension APIClient {
  /// Creates a data task `Publisher` from a `URLRequest` using this `APIClient`'s `URLSession`. Any
  /// errors will be mapped to an `KantanError`. If the response status code is outside of
  /// 200 (inclusive) to 400 (exclusive), then the `Publisher` will emit an invalidStatus
  /// `KantanError`.
  /// - Parameter request: The `URLRequest` to create a data task `Publisher` for
  /// - Returns: A `Publisher` that emits `Data` or `Error`.
  private func dataTaskPublisher(withRequest request: URLRequest) -> AnyPublisher<Data, Error> {
    urlSession
      .dataTaskPublisher(for: request)
      .mapError { KantanError.unknown(reason: $0.localizedDescription) }
      .tryMap { out -> Data in
        guard let response = out.response as? HTTPURLResponse else { throw KantanError.invalidResponse }
        guard 200..<400 ~= response.statusCode else { throw KantanError.invalidStatus(statusCode: response.statusCode) }
        return out.data
      }
      .eraseToAnyPublisher()
  }
}
