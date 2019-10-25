//
//  RestaurantController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

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

class RestaurantController {
    
    private let baseURL = URL(string: "https://buildweek-foodiefun.herokuapp.com/restaurants/restaurants")!
    private let fireBaseURL = URL(string: "https://foodiefun-34f43.firebaseio.com/")!
    var searchedRestaurants: [RestaurantRepresentation] = []
    
    func searchForRestaurant(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error searching for restaurant with search term \(searchTerm): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let restaurantRepresentations = try JSONDecoder().decode(RestaurantRepresentations.self, from: data).results
                self.searchedRestaurants = restaurantRepresentations
                completion(nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    init() {
        fetchRestaurantsFromServer()
    }
    
    func fetchRestaurantsFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching restaurants: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data return from restaurant fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let restaurants = try decoder.decode([String: RestaurantRepresentation].self, from: data).map({ $0.value })
                self.updateRestaurant(with: restaurants)
            } catch {
                NSLog("Error decoding RestaurantRepresentation: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateRestaurant(with representations: [RestaurantRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.id })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var restaurantsToCreate = representationsByID
        
        let context = CoreDataStack.shared.restaurantContainer.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
                
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingRestaurants = try context.fetch(fetchRequest)
                
                for restaurant in existingRestaurants {
                    
                    guard let identifier = restaurant.id,
                        let representation = representationsByID[identifier]
                        else { continue }
                    
                    restaurant.cuisine = representation.cuisine
                    restaurant.hours = representation.hours
                    restaurant.location = representation.location
                    restaurant.name = representation.name
                    restaurant.photos = representation.photos
                    restaurant.rating = representation.rating
                    restaurant.reviews = representation.reviews
                    
                    restaurantsToCreate.removeValue(forKey: identifier)
                }
                
                for representation in restaurantsToCreate.values {
                    Restaurant(restaurantRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
                
            } catch {
                NSLog("Error fetching restaurants from persistent store: \(error)")
            }
        }
    }
    
    func put(restaurant: Restaurant, completion: @escaping () -> Void = { }) {
        
        let identifier = restaurant.id ?? UUID()
        restaurant.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let restaurantRepresentation = restaurant.restaurantRepresentation else {
            NSLog("Restaurant Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(restaurantRepresentation)
        } catch {
            NSLog("Error encoding restaurant representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting restaurant: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteRestaurantFromServer(restaurant: Restaurant, completion: @escaping () -> Void = { }) {
        
        let identifier = restaurant.id ?? UUID()
        restaurant.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing restaurant: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func createRestaurant(with cuisine: String, hours: String, location: String, name: String, photos: String, rating: String, reviews: String, context: NSManagedObjectContext) {
        
        let restaurant = Restaurant(cuisine: cuisine, hours: hours, location: location, name: name, photos: photos, rating: rating, reviews: reviews, context: context)
        CoreDataStack.shared.save(context: context)
        put(restaurant: restaurant)
    }
    
    func updateRestaurant(restaurant: Restaurant, cuisine: String, hours: String, location: String, name: String, photos: String, rating: String, reviews: String, context: NSManagedObjectContext) {
        
        CoreDataStack.shared.save(context: context)
        put(restaurant: restaurant)
    }
    
    func deleteRestaurant(restaurant: Restaurant, context: NSManagedObjectContext) {
        
        deleteRestaurantFromServer(restaurant: restaurant)
        CoreDataStack.shared.foodieMainContext.delete(restaurant)
        CoreDataStack.shared.save(context: context)
    }
}
