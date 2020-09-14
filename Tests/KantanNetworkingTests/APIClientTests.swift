//
//  APIClientTests.swift
//  KantanNetworkingTests
//
//  Created by Alex Fargo on 9/9/20.
//

import XCTest
import Combine
@testable import KantanNetworking

// TODO: Improve the request tests
class APIClientTests: XCTestCase {
  var apiClient: APIClient!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    self.apiClient = APIClient()
  }
  
  func testMakeUrlComponents() throws {
    var routable = RoutableMocks.endpoint1
    var components = apiClient.makeUrlComponents(from: routable)
    XCTAssertEqual(components.host, "some.website.com")
    XCTAssertEqual(components.scheme, "https")
    XCTAssertEqual(components.path, "/path/to/endpoint/1")
    XCTAssertNil(components.queryItems)
    
    routable = RoutableMocks.endpoint2(id: "myId", name: "Alex", age: 22)
    components = apiClient.makeUrlComponents(from: routable)
    XCTAssertEqual(components.host, "some.website.com")
    XCTAssertEqual(components.scheme, "https")
    XCTAssertEqual(components.path, "/path/to/endpoint/2")
    XCTAssertEqual(components.queryItems, [.init(name: "id", value: "myId")])
  }
  
  func testMakeUrl() throws {
    var routable = RoutableMocks.endpoint1
    XCTAssertNoThrow(try apiClient.makeUrl(from: routable))
    routable = RoutableMocks.endpoint2(id: "myID", name: "Alex", age: 22)
    XCTAssertNoThrow(try apiClient.makeUrl(from: routable))
    routable = RoutableMocks.badEndpoint
    XCTAssertThrowsError(try apiClient.makeUrl(from: routable))
  }
  
  func testMakeUrlRequest() throws {
    var routable = RoutableMocks.endpoint1
    XCTAssertNoThrow(try apiClient.makeUrlRequest(from: routable))
    routable = RoutableMocks.endpoint2(id: "myID", name: "Alex", age: 22)
    XCTAssertNoThrow(try apiClient.makeUrlRequest(from: routable))
    routable = RoutableMocks.badEndpoint
    XCTAssertThrowsError(try apiClient.makeUrlRequest(from: routable))
  }
  
  func testRequest() throws {
    let completionExp = expectation(description: "completion")
    apiClient.request(for: RoutableMocks.endpoint1) { (result: Result<String, Error>) in
      completionExp.fulfill()
    }
    wait(for: [completionExp], timeout: 1.0)
  }
  
  func testRequestImage() throws {
    let completionExp = expectation(description: "completion")
    apiClient.requestImage(for: RoutableMocks.endpoint1) { result in
      completionExp.fulfill()
    }
    wait(for: [completionExp], timeout: 1.0)
  }
}
