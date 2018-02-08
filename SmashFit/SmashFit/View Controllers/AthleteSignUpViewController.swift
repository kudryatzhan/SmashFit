//
//  SignUpViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 1/30/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class AthleteSignUpViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var gymNameTextField: UITextField!
    
    
    // MARK: - App Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    // Sign up implementation
    @IBAction func registerAccount(_ sender: UIButton) {
        
        // Validate the input
        guard
            let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let gymName = gymNameTextField.text, !gymName.isEmpty else {
                
                // Create an alert
                let alertController = UIAlertController(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Register the user account on Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                // Create an alert
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Save the name of the user
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // Dismiss the keyboard
            self.view.endEditing(true)
            
            // Send verification email
            user?.sendEmailVerification(completion: nil)
            
            let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                
                // Dismiss the current view controller
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            // Save athlete user to Firebase
            if let user = user {
                
                //FIXME: - Fix it 
                let athlete = User(uid: user.uid, name: name, email: email, gymName: gymName, isAthlete: true)
                UserController.shared.saveToFirebase(user: athlete)
                print(athlete)
            } else {
                print("User to save missing something.")
            }
        }
    }
}
