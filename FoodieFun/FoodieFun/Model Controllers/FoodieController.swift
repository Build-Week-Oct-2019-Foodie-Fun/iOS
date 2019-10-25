//
//  FoodieController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

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
    private let fireBaseURL = URL(string: "https://foodiefun-34f43.firebaseio.com/")!
    
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
    
    init() {
        fetchFoodiesFromServer()
    }
    
    func fetchFoodiesFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching foodies: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data return from foodie fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let foodies = try decoder.decode([String: FoodieRepresentation].self, from: data).map({ $0.value })
                self.updateFoodies(with: foodies)
            } catch {
                NSLog("Error decoding FoodieRepresentation: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateFoodies(with representations: [FoodieRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.id })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var foodiesToCreate = representationsByID
        
        let context = CoreDataStack.shared.foodieContainer.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<Foodie> = Foodie.fetchRequest()
                
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingFoodies = try context.fetch(fetchRequest)
                
                for foodie in existingFoodies {
                    
                    guard let identifier = foodie.id,
                        let representation = representationsByID[identifier]
                        else { continue }
                    
                    foodie.username = representation.username
                    foodie.userEmail = representation.userEmail
                    foodie.password = representation.userPassword
                    
                    foodiesToCreate.removeValue(forKey: identifier)
                }
                
                for representation in foodiesToCreate.values {
                    Foodie(foodieRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
                
            } catch {
                NSLog("Error fetching foodies from persistent store: \(error)")
            }
        }
    }
    
    func put(foodie: Foodie, completion: @escaping () -> Void = { }) {
        
        let identifier = foodie.id ?? UUID()
        foodie.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let foodieRepresentation = foodie.foodieRepresentation else {
            NSLog("Foodie Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(foodieRepresentation)
        } catch {
            NSLog("Error encoding foodie representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting foodie: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteFoodieFromServer(foodie: Foodie, completion: @escaping () -> Void = { }) {
        
        let identifier = foodie.id ?? UUID()
        foodie.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing foodie: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func createFoodie(with username: String, userEmail: String, password: String, context: NSManagedObjectContext) {
        
        let foodie = Foodie(username: username, userEmail: userEmail, password: password, context: context)
        CoreDataStack.shared.save(context: context)
        put(foodie: foodie)
    }
    
    func updateFoodie(foodie: Foodie, username: String, userEmail: String, password: String, context: NSManagedObjectContext) {
        
        CoreDataStack.shared.save(context: context)
        put(foodie: foodie)
    }
    
    func deleteFoodie(foodie: Foodie, context: NSManagedObjectContext) {
        
        deleteFoodieFromServer(foodie: foodie)
        CoreDataStack.shared.foodieMainContext.delete(foodie)
        CoreDataStack.shared.save(context: context)
    }
}
