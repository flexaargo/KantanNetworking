//
//  KantanErrorTests.swift
//  KantanNetworkingTests
//
//  Created by Alex Fargo on 9/13/20.
//

import XCTest
@testable import KantanNetworking

class KantanErrorTests: XCTestCase {
  func testErrorDescriptions() throws {
    var error: KantanError = .unknown()
    XCTAssertEqual(error.description, "[KANTAN ERROR] Unknown ")
    error = .makeUrl()
    XCTAssertEqual(error.description, "[KANTAN ERROR] Could not make url. Reason: unspecified")
    error = .makeUrlRequest()
    XCTAssertEqual(error.description, "[KANTAN ERROR] Could not make url request. Reason: unspecified")
    error =  .decoding()
    XCTAssertEqual(error.description, "[KANTAN ERROR] There was an error decoding the response. Reason: unspecified")
    error = .invalidResponse
    XCTAssertEqual(error.description, "[KANTAN ERROR] Received invalid response from server.")
    error = .invalidStatus(statusCode: 400)
    XCTAssertEqual(error.description, "[KANTAN ERROR] Received invalid status code from server. Status code: 400")
  }
}
