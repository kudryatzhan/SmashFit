//
//  ResetPasswordViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 1/30/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        // Validate the input
        guard let emailAddress = emailTextField.text, !emailAddress.isEmpty else {
            
            let alertController = UIAlertController(title: "Input Error", message: "Please provide your email address for password reset.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Send password reset email
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            
            let title = (error == nil) ? "Password reset Follow-up" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                
                if error == nil {
                    
                    // Dismiss keyboard
                    self.view.endEditing(true)
                    
                    // Present the main view
                    if let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
                        UIApplication.shared.keyWindow?.rootViewController = mainViewController
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
