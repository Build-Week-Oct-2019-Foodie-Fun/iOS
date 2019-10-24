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
    // TODO: - ADD URL
    private let apiKey = "5At6R1sT1HctQW0PSJ3Pl2EcIWPfH4RAMZozuXWLbm7-z_tqYODpFJOiGWd2XoUEn94N1QM4GCNOZ5hX4PM38ehEAf2gsqLQtp4QczfUZmCOJQm3lnVJ4B1UjUaxXXYx"
    //private let baseURL = URL(string: "")!
    
    
    // SIGNUP
    func signUp(with foodie: Foodie, completion: @escaping (Error?) -> ()) {
        
        
    }
    
//    var restaurants: [Restaurant] = [Restaurant(name: "Cheesecake Factory", imageName: "foodItem", foodItem: "Beef Plate"),
//                                     Restaurant(name: "Merriman's", imageName: "foodItem1", foodItem: "Shrimp Scampi"),
//                                     Restaurant(name: "Mi's", imageName: "foodItem2", foodItem: "Steak"),
//                                     Restaurant(name: "Papa Kona", imageName: "foodItem3", foodItem: "Panini")]
    
    
    
    }

