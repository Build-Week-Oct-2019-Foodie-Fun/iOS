//
//  ReviewRepresentation.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct ReviewRepresentation: Equatable, Codable {
    
    let cuisine: String?
    let id: UUID?
    let name: String?
    let photo: String?
    let price: Double?
    let rating: String?
    let restaurantName: String?
    let review: String?
}

struct ReviewRepresentations {
    let results: [ReviewRepresentation]
}
