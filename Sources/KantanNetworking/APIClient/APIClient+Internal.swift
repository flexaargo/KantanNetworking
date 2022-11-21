//
//  APIClient+Internal.swift
//  KantanNetworking
//
//  Created by  Alex Fargo on 11/20/22
//

#if(os(iOS))

import Foundation
import Combine
import SwiftUI

// MARK: - Internal UIImage Requests
extension APIClient {
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
extension APIClient {
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
extension APIClient {
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

#endif