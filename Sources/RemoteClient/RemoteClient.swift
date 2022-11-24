//
//  RemoteClient.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/8/20.
//

import Foundation

/// A `RemoteClient` is configured and used to make network requests to a single host.
public protocol RemoteClient {
    /// Used to configure how the `RemoteClient` is setup and behaves.
    var configuration: RemoteConfiguration { get set }

    /// Makes a request to the configured host using information from the ``Routable``. Decodes a `Response` from the the data payload. This method will throw an error if the HTTP response is not OK or if there was an error decoding the `Response`
    /// - Parameters:
    ///   - responseType: The expected response type from the request.
    ///   - route: The ``Routable`` used to configure the request.
    /// - Returns: An instance of the ``Response``
    func request<Response>(_ responseType: Response.Type, from route: Routable) async throws -> Response where Response: Decodable

    /// Creates a URL from the `route` using the configured host.
    /// - Parameter route: The ``Route`` used to create the `URL`
    /// - Returns: A `URL` instance
    func createURL(from route: Routable) throws -> URL
}
