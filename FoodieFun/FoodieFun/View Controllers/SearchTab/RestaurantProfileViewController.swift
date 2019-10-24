//
//  RestaurantProfileViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class RestaurantProfileViewController: UIViewController {
    
    var restaurant: Restaurant?
    let restaurantControllerTest = RestaurantControllerTest()
    
    var array: [String] = []

    // MARK: - Outlets
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let restaurant = restaurant else { return }
        
        restaurantTitle.text = restaurant.name
        
    }


}

extension RestaurantProfileViewController: UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuInfo", for: indexPath) as? RestaurantProfileTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
    
}
