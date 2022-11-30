//
//  RoutableTests.swift
//  KantanNetworkingTests
//
//  Created by  Alex Fargo on 11/21/22
//

import XCTest
@testable import KantanNetworking

class RoutableTests: XCTestCase {
    func testEmptyRoutable() {
        let route: Routable = MockRoute(method: .get)
        let components = route.urlComponents(withHost: "host.com")

        XCTAssert(components.host == "host.com")
        XCTAssert(components.scheme == "https")
        XCTAssert(components.path.isEmpty)
        XCTAssertNil(components.queryItems)
    }

    func testFilledRoutable() {
        let route: Routable = MockRoute(
            method: .get,
            path: "/path/to/api",
            parameters: ["parameter": "some value"]
        )
        let components = route.urlComponents(withHost: "host.com")

        XCTAssert(components.host == "host.com")
        XCTAssert(components.scheme == "https")
        XCTAssert(components.path == "/path/to/api")
        XCTAssert(components.queryItems == [URLQueryItem(name: "parameter", value: "some value")])
    }
}
