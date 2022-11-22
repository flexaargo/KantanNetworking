//
//  MockRoute.swift
//  KantanNetworkingTests
//
//  Created by  Alex Fargo on 11/21/22
//

import KantanNetworking

struct MockRoute: Routable {
    var method: KantanNetworking.HTTPMethod
    var path: String?
    var parameters: HTTPParameters?
    var body: HTTPBody?
    var headers: HTTPHeaders?
}
