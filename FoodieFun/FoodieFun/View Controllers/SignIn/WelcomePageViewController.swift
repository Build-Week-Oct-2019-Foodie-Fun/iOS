//
//  WelcomePageViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    // MARK: - Properties
    let customFontColor = UIColor(displayP3Red: 255/255, green: 221/255, blue: 103/255, alpha: 1).cgColor
    
    // MARK: - Outlets
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        
        signIn.layer.cornerRadius = 8.0
        createAccount.layer.cornerRadius = 8.0
        createAccount.layer.borderColor = customFontColor
        createAccount.layer.borderWidth = 2.0
    }

}

