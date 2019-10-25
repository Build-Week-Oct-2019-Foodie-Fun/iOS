//
//  ReviewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

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

class ReviewController {
    
    private let fireBaseURL = URL(string: "https://foodiefun-34f43.firebaseio.com/")!

    
    init() {
        fetchReviewsFromServer()
    }
    
    func fetchReviewsFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = fireBaseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching reviews: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data return from review fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let reviews = try decoder.decode([String: ReviewRepresentation].self, from: data).map({ $0.value })
                self.updateReviews(with: reviews)
            } catch {
                NSLog("Error decoding ReviewRepresentation: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateReviews(with representations: [ReviewRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.id })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var reviewsToCreate = representationsByID
        
        let context = CoreDataStack.shared.reviewContainer.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
                
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingReviews = try context.fetch(fetchRequest)
                
                for review in existingReviews {
                    
                    guard let identifier = review.id,
                        let representation = representationsByID[identifier],
                        let price = representation.price
                        else { continue }
                    
                    review.cuisine = representation.cuisine
                    review.name = representation.name
                    review.photo = representation.photo
                    review.price = price
                    review.rating = representation.rating
                    review.restaurantName = representation.restaurantName
                    review.review = representation.review
                    
                    reviewsToCreate.removeValue(forKey: identifier)
                }
                
                for representation in reviewsToCreate.values {
                    Review(reviewRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
                
            } catch {
                NSLog("Error fetching reviews from persistent store: \(error)")
            }
        }
    }
    
    func put(review: Review, completion: @escaping () -> Void = { }) {
        
        let identifier = review.id ?? UUID()
        review.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let reviewRepresentation = review.reviewRepresentation else {
            NSLog("Review Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(reviewRepresentation)
        } catch {
            NSLog("Error encoding review representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting review: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteReviewFromServer(review: Review, completion: @escaping () -> Void = { }) {
        
        let identifier = review.id ?? UUID()
        review.id = identifier
        
        let requestURL = fireBaseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing review: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func createReview(with cuisine: String, name: String, photo: String, price: Double, rating: String, restaurantName: String, review: String, context: NSManagedObjectContext) {
        
        let review = Review(cuisine: cuisine, name: name, photo: photo, price: price, rating: rating, restaurantName: restaurantName, review: review, context: context)
        CoreDataStack.shared.save(context: context)
        put(review: review)
    }
    
    func updateReview(review: Review, cuisine: String, name: String, photo: String, price: Double, rating: String, restaurantName: String, context: NSManagedObjectContext) {
        
        CoreDataStack.shared.save(context: context)
        put(review: review)
    }
    
    func deleteReview(review: Review, context: NSManagedObjectContext) {
        
        deleteReviewFromServer(review: review)
        CoreDataStack.shared.reviewMainContext.delete(review)
        CoreDataStack.shared.save(context: context)
    }
}
