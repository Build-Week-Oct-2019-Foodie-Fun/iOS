//
//  SignInViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    let foodieController = FoodieController()
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signIn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Actions
    @IBAction func signInTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else { return }
        
        let foodie = FoodieRepresentation(username: nil, userEmail: email, userPassword: password, id: nil)
        
        signIn(with: foodie)
    }
    
    
    // MARK: - Methods
    private func updateViews() {
        signIn.layer.cornerRadius = 8.0
    }
    
    func signIn(with foodie: FoodieRepresentation) {
        foodieController.signIn(with: foodie) { (error) in
            if let error = error {
                NSLog("Error occured during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
