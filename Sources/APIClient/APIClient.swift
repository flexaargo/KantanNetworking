//
//  APIClient.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation

public final class APIClient: RemoteClient {
    public var configuration: RemoteConfiguration

    private lazy var urlSession: URLSession = {
        let sessionConfig: URLSessionConfiguration = .default
        return URLSession(configuration: sessionConfig)
    }()

    internal var decoder: JSONDecoder { configuration.decoder }

    public init(configuration: RemoteConfiguration) {
        self.configuration = configuration
    }

    public convenience init(host: String) {
        let configuration = RemoteConfiguration(host: host)
        self.init(configuration: configuration)
    }

    public func request<Response>(
        _ responseType: Response.Type,
        from route: Routable
    ) async throws -> Response where Response: Decodable {
        let urlRequest = try createURLRequest(from: route)
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw KantanError.invalidResponse(data: data)
        }

        guard 200..<400 ~= response.statusCode else {
            throw KantanError.invalidResponse(data: data, response: response)
        }

        return try decoder.decode(responseType, from: data)
    }
}
