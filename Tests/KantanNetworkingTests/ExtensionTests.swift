//
//  ExtensionTests.swift
//  KantanNetworkingTests
//
//  Created by Alex Fargo on 9/13/20.
//

import XCTest
@testable import KantanNetworking

class ExtensionTests: XCTestCase {
  let dict: [String: AnyHashable] = ["param1": 10, "param2": "test", "param3": false]
  
  func testDictionaryToData() throws {
    guard let data = dict.data() else {
      XCTFail("Expected data to be non-nil")
      return
    }
    guard let recoveredDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyHashable] else {
      XCTFail("Expected recovered dict to be non-nil")
      return
    }
    XCTAssertEqual(recoveredDict, dict)
  }
  
  func testDictionaryAddition() throws {
    var otherDict: [String: AnyHashable] = ["param1": 2, "param4": true]
    otherDict += dict
    
    XCTAssertEqual(otherDict, ["param1": 10, "param2": "test", "param3": false, "param4": true])
  }
}
