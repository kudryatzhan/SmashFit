//
//  WelcomeViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 1/29/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    // MARK - IBActions
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions

    @IBAction func unwindToWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    // Sign in implementation
    @IBAction func login(_ sender: UIButton) {
        
        // Validate the input
        guard
            let emailAddress = emailTextField.text, !emailAddress.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                
                let alertController = UIAlertController(title: "Login Error", message: "Both fields must not be blank.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                
                present(alertController, animated: true, completion: nil)
                return
        }
        
        // Perform login by calling Firebase APIs
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            // Dismiss keyboard
            self.view.endEditing(true)
            
            // Present the main view
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}

