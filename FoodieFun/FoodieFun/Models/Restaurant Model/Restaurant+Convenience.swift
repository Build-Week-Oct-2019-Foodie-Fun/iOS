//
//  Restaurant+Convenience.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Restaurant {
    
    var restaurantRepresentation: RestaurantRepresentation? {
        
        guard let cuisine = cuisine,
            let hours = hours,
            let id = id,
            let location = location,
            let name = name,
            let photos = photos,
            let rating = rating,
            let reviews = reviews else { return nil }
        
        
        return RestaurantRepresentation(cuisine: cuisine,
                                        hours: hours,
                                        id: id,
                                        location: location,
                                        name: name,
                                        photos: photos,
                                        rating: rating,
                                        reviews: reviews)
    }
    
    @discardableResult convenience init(cuisine: String,
                                        hours: String,
                                        id: UUID = UUID(),
                                        location: String,
                                        name: String,
                                        photos: String,
                                        rating: String,
                                        reviews: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.cuisine = cuisine
        self.hours = hours
        self.location = location
        self.name = name
        self.photos = photos
        self.rating = rating
        self.reviews = reviews
    }
    
    @discardableResult convenience init?(restaurantRepresentation: RestaurantRepresentation, context: NSManagedObjectContext) {
        
        guard let cuisine = restaurantRepresentation.cuisine,
            let hours = restaurantRepresentation.hours,
            let id = restaurantRepresentation.id,
            let location = restaurantRepresentation.location,
            let name = restaurantRepresentation.name,
            let photos = restaurantRepresentation.photos,
            let rating = restaurantRepresentation.rating,
            let reviews = restaurantRepresentation.reviews else { return nil }
        
        self.init(cuisine: cuisine,
                  hours: hours,
                  id: id,
                  location: location,
                  name: name,
                  photos: photos,
                  rating: rating,
                  reviews: reviews,
                  context: context)
    }
}
