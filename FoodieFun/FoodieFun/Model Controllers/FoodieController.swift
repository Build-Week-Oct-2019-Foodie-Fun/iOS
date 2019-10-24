//
//  FoodieController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum FoodieHTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum FoodieNetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
}

enum FoodieHeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case value = "application/json"
}

class FoodieController {
    
    // MARK: - Properties
    var bearer: Bearer?
    private let baseURL = URL(string: "https://buildweek-foodiefun.herokuapp.com/")!
    
    func signUp(with foodie: FoodieRepresentation, completion: @escaping (Error?) -> ()) {
        
        let requestURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("user")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue(FoodieHeaderNames.value.rawValue, forHTTPHeaderField: FoodieHeaderNames.contentType.rawValue)
        
        do {
            let userJSON = try JSONEncoder().encode(foodie)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding the Foodie object \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing up foodie: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.FoodieFun", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            completion(nil)
        }.resume()
    }
    
    func signIn(with foodie: FoodieRepresentation, completion: @escaping (Error?) -> ()) {
        
        let requestURL = baseURL
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue(FoodieHeaderNames.value.rawValue, forHTTPHeaderField: FoodieHeaderNames.contentType.rawValue)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(foodie)
        } catch {
            NSLog("Error encoding foodie for sign in: \(error)")
            completion(error)
        }
            
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in the foodie: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JesseRuiz.Foodie", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.JesseRuiz.FoodieFun", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("There was an error decoding the bearer token: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
}
