//
//  Review+Convenience.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Review {
    
    var reviewRepresentation: ReviewRepresentation? {
        
        guard let cuisine = cuisine,
            let id = id,
            let name = name,
            let photo = photo,
            let rating = rating,
            let restaurantName = restaurantName,
            let review = review else { return nil }
        
        
        return ReviewRepresentation(cuisine: cuisine,
                                    id: id,
                                    name: name,
                                    photo: photo,
                                    price: price,
                                    rating: rating,
                                    restaurantName: restaurantName,
                                    review: review)
    }
    
    @discardableResult convenience init(cuisine: String,
                                        id: UUID = UUID(),
                                        name: String,
                                        photo: String,
                                        price: Double,
                                        rating: String,
                                        restaurantName: String,
                                        review: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.cuisine = cuisine
        self.id = id
        self.name = name
        self.photo = photo
        self.price = price
        self.rating = rating
        self.restaurantName = restaurantName
        self.review = review
    }
    
    @discardableResult convenience init?(reviewRepresentation: ReviewRepresentation, context: NSManagedObjectContext) {
        
        guard let cuisine = reviewRepresentation.cuisine,
            let id = reviewRepresentation.id,
            let name = reviewRepresentation.name,
            let photo = reviewRepresentation.photo,
            let price = reviewRepresentation.price,
            let rating = reviewRepresentation.rating,
            let restaurantName = reviewRepresentation.restaurantName,
            let review = reviewRepresentation.review else { return nil }
        
        self.init(cuisine: cuisine,
                  id: id,
                  name: name,
                  photo: photo,
                  price: price,
                  rating: rating,
                  restaurantName: restaurantName,
                  review: review,
                  context: context)
    }
}
