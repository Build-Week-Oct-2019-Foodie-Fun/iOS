//
//  ProfileViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

    
    

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension ProfileViewController: UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfo", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
    
    
    
}
