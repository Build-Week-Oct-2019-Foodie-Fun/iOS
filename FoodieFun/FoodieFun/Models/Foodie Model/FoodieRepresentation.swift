//
//  FoodieRepresentation.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct FoodieRepresentation: Equatable, Codable {
    
    let username: String?
    let userEmail: String?
    let userPassword: String?
    let id: UUID?
}

struct FoodieRepresentations: Codable {
    let results: [FoodieRepresentation]
}
