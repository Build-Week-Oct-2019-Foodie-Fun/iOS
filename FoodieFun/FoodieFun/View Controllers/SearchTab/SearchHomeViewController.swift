//
//  SearchHomeViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SearchHomeViewController: UIViewController {
    
    // MARK: - Properties
    let foodieController = FoodieController()
    let restaurantControllerTest = RestaurantControllerTest()
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension SearchHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return restaurantControllerTest.restaurantsTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedRestaurant", for: indexPath) as? SearchHomeCollectionViewCell else { return UICollectionViewCell() }
        
        let restaurant = restaurantControllerTest.restaurantsTest[indexPath.item]
        cell.restaurantTest = restaurant
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let RestaurantProfileVC = storyboard?.instantiateViewController(identifier: "RestaurantProfileViewController") as? RestaurantProfileViewController else { return }
        self.navigationController?.pushViewController(RestaurantProfileVC, animated: true)
    }
    
    
    
}
