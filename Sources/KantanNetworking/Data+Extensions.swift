//
//  Data+Extensions.swift
//  KantanNetworking
//
//  Created by Alex Fargo on 9/9/20.
//

import Foundation

/// Made for use in `Routable` make... extensions
internal extension Dictionary where Key == String, Value == AnyHashable {
  func data() -> Data? {
    try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }

  /// Adds the right hand dictionary to the left hand dictionary. If a key already exists in the left hand side, then
  /// the associated value is replaced with the right hand side's value.
  /// - Parameters:
  ///   - lhs: A dictionary.
  ///   - rhs: A dictionary.
  /// - Returns: A new dictionary containing left and right hand side.
  static func +=(lhs: inout Self, rhs: Self) {
    rhs.forEach{ (key, value) in
      lhs[key] = value
    }
  }
}
