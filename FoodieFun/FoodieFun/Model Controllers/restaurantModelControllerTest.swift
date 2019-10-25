//
//  restaurantModelControllerTest.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class RestaurantControllerTest {
    
    // MARK: - Properties
    
    var restaurantsTest: [RestaurantTest] = [RestaurantTest(name: "Cheesecake Factory", imageName: "foodItem", foodItem: "Beef Plate"),
                                     RestaurantTest(name: "Merriman's", imageName: "foodItem1", foodItem: "Shrimp Scampi"),
                                     RestaurantTest(name: "Mi's", imageName: "foodItem2", foodItem: "Steak"),
                                     RestaurantTest(name: "Papa Kona", imageName: "foodItem3", foodItem: "Panini")]
    
    
    
    }

