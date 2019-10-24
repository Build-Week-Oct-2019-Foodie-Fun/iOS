//
//  ReviewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum ReviewHTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum ReviewNetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
}

enum ReviewHeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}
