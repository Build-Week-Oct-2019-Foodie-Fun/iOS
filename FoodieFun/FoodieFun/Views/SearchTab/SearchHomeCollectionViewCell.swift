//
//  SearchHomeCollectionViewCell.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SearchHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var restaurantTitle: UILabel!
    
    var restaurantTest: RestaurantTest? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let restaurantTest = restaurantTest else { return }
        
        foodImage.image = restaurantTest.image
        foodTitle.text = restaurantTest.foodItem
        restaurantTitle.text = restaurantTest.name
        
    }
}
    

