//
//  CreateAccountViewController.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    // MARK: - Properties
    let foodieController = FoodieController()
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var create: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    // MARK: - Actions
    @IBAction func createTapped(_ sender: UIButton) {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !name.isEmpty,
            !email.isEmpty,
            !password.isEmpty else { return }
        
        let foodie = FoodieRepresentation(username: name, userEmail: email, userPassword: password, id: nil)
        
        createAccuont(with: foodie)
    }
    
    private func updateViews() {
        
        create.layer.cornerRadius = 8.0
    }
    
    func createAccuont(with foodie: FoodieRepresentation) {
        foodieController.signUp(with: foodie) { (error) in
            
            if let error = error {
                NSLog("Error occured during create account: \(error)")
            } else {
                let alert = UIAlertController(title: "You have successfully created an account",
                                              message: nil, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
}
