//
//  RestaurantController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum RestaurantHTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum RestaurantNetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
}

enum RestaurantHeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}
