//
//  RoutableTests.swift
//  KantanNetworkingTests
//
//  Created by Alex Fargo on 9/9/20.
//

import XCTest
@testable import KantanNetworking

class RoutableTests: XCTestCase {
  func testMakeURLComponents() throws {
    let endpoint1Components = RoutableMocks.endpoint1.makeUrlComponents()
    XCTAssertEqual(endpoint1Components.host, "some.website.com")
    XCTAssertEqual(endpoint1Components.scheme, "https")
    XCTAssertEqual(endpoint1Components.path, "/path/to/endpoint/1")
    XCTAssertNil(endpoint1Components.queryItems)
    
    let endpoint2Components = RoutableMocks.endpoint2(id: "myId", name: "Alex", age: 22).makeUrlComponents()
    XCTAssertEqual(endpoint2Components.host, "some.website.com")
    XCTAssertEqual(endpoint2Components.scheme, "https")
    XCTAssertEqual(endpoint2Components.path, "/path/to/endpoint/2")
    XCTAssertEqual(endpoint2Components.queryItems, [.init(name: "id", value: "myId")])
  }
  
  func testMakeUrl() throws {
    let endpoint1Url = RoutableMocks.endpoint1.makeUrl()?.absoluteString
    XCTAssertEqual(endpoint1Url, "https://some.website.com/path/to/endpoint/1")
    
    let endpoint2Url = RoutableMocks.endpoint2(id: "myId", name: "Alex", age: 22).makeUrl()?.absoluteString
    XCTAssertEqual(endpoint2Url, "https://some.website.com/path/to/endpoint/2?id=myId")
  }
  
  func testMakeUrlRequest() throws {
    let endpoint1Request = RoutableMocks.endpoint1.makeUrlRequest()
    XCTAssertEqual(endpoint1Request?.allHTTPHeaderFields, [:])
    XCTAssertNil(endpoint1Request?.httpBody)
    
    let endpoint2Request = RoutableMocks.endpoint2(id: "myId", name: "Alex", age: 22).makeUrlRequest()
    XCTAssertEqual(endpoint2Request?.allHTTPHeaderFields, ["Bearer": "someToken", "Content-Type": "application/json"])
    XCTAssertNotNil(endpoint2Request?.httpBody)
  }
}
