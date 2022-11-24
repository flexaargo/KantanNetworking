//
//  KantanError.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation

public enum KantanError: Error, CustomStringConvertible {
    case failedToCreateURL(route: Routable, host: String)
    case invalidResponse(data: Data, response: HTTPURLResponse? = nil)

    public var description: String {
        var description = "[KANTAN ERROR] "
        switch self {
        case let .failedToCreateURL(route, host):
            description.append("Failed to create a URL. Route: \(route) Host: \(host)")
        case let .invalidResponse(data, response):
            let dataString = String(data: data, encoding: .utf8) ?? "None"
            let responseString = response != nil ? "\(response!.statusCode)" : "None"
            description
                .append(
                    "Received invalid response. Data: \(dataString) Response: \(responseString)"
                )
        }
        return description
    }
}
