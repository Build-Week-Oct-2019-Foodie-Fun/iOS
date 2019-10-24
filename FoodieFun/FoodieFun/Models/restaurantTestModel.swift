//
//  restaurantTestModel.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

struct Restaurant {
    
    var name: String
    var image: UIImage
    var foodItem: String
    
    init(name: String, imageName: String, foodItem: String) {
        self.name = name
        self.image = UIImage(named: imageName)!
        self.foodItem = foodItem
    }
        
    
    
//    struct Items {
//        let appetizers: [Appetizers]
//
//        struct Appetizers {
//            let appetizer: Appetizer
//        }
//
//        struct Appetizer {
//            let name: String
//        }
//
//        let entrees: [Entrees]
//
//        struct Entrees {
//            let entree: Entree
//        }
//
//        struct Entree {
//            let name: String
//        }
//
//        let desserts: [Desserts]
//
//        struct Desserts {
//            let dessert: Dessert
//        }
//
//        struct Dessert {
//            let name: String
//        }
//
//        let drinks: [Drinks]
//
//        struct Drinks {
//            let drink: Drink
//        }
//
//        struct Drink {
//            let name: String
//        }
//    }
}
