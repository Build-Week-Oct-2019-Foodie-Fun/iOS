//
//  Foodie+Convenience.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Foodie {
    
    var foodieRepresentation: FoodieRepresentation? {
        
        guard let username = username,
            let userEmail = userEmail,
            let userPassword = password,
            let id = id else { return nil }
        
        
        return FoodieRepresentation(username: username,
                                    userEmail: userEmail,
                                    userPassword: userPassword,
                                    id: id)
    }
    
    @discardableResult convenience init(username: String,
                                        userEmail: String,
                                        password: String,
                                        id: UUID = UUID(),
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.username = username
        self.userEmail = userEmail
        self.password = password
        self.id = id
    }
    
    @discardableResult convenience init?(foodieRepresentation: FoodieRepresentation, context: NSManagedObjectContext) {
        
        guard let username = foodieRepresentation.username,
            let userEmail = foodieRepresentation.userEmail,
            let password = foodieRepresentation.userPassword,
            let id = foodieRepresentation.id else { return nil }
        
        self.init(username: username,
                  userEmail: userEmail,
                  password: password,
                  id: id,
                  context: context)
    }
}
