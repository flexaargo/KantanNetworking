//
//  RemoteClient.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/8/20.
//

#if(os(iOS))

import Foundation
import SwiftUI
import Combine

public protocol RemoteClient: AnyObject {
  init(configuration: RemoteConfiguration)

  /// Makes URLComponents from a given routable.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  func makeUrlComponents(from routable: Routable) -> URLComponents
  /// Makes URL from a given routable.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  func makeUrl(from routable: Routable) throws -> URL
  /// Makes URLRequest from a given routable.
  /// - Parameter routable: Contains information about the `URL` and `URLRequest`.
  func makeUrlRequest(from routable: Routable) throws -> URLRequest

  // MARK: - Completions

  /// Makes a request for a routable and completes with a result. The result with either contain the
  /// wanted `Response` or an `Error`.
  /// - Parameters:
  ///   - routable: The routable to make a request for.
  ///   - completion: Closure to execute with given result.
  func request<Response>(for routable: Routable, completion: @escaping (Result<Response, Error>) -> Void) where Response: Decodable

  /// Makes a request for a routable and completes with a result. The result with either contain a
  /// `UIImage` or an `Error`.
  /// - Parameters:
  ///   - routable: The routable to make a request for.
  ///   - completion: Closure to execute with given result.
  func requestImage(for routable: Routable, completion: @escaping (Result<UIImage, Error>) -> Void)

  // MARK: - Publishers

  /// Creates a Publisher that emits a `Response` or an `Error`.
  /// - Parameter routable: The routable to make a request for.
  func requestPublisher<Response>(for routable: Routable) -> AnyPublisher<Response, Error> where Response: Decodable

  /// Creates a Publisher that emits a `UIImage` or an `Error`.
  /// - Parameter routable: The routable to make a request for.
  func requestImagePublisher(for routable: Routable) -> AnyPublisher<UIImage, Error>
}

#endif