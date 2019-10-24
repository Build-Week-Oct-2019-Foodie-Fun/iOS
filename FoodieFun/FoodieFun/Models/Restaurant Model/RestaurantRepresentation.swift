//
//  RestaurantRepresentation.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct RestaurantRepresentation: Equatable, Codable {
    
    let cuisine: String?
    let hours: String?
    let id: UUID?
    let location: String?
    let name: String?
    let photos: String?
    let rating: String?
    let reviews: String?
}

struct RestaurantRepresentations: Codable {
    let results: [RestaurantRepresentation]
}
