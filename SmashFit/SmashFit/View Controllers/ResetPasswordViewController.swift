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
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Send notifications when keyboard status change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Dismiss keyboard
        self.view.endEditing(true)
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
    
    // background was tapped
    @IBAction func backgroundWasTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - Helper Methods
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        adjustMiddleConstraint(to: -keyboardFrame.height/3)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustMiddleConstraint(to: 0)
    }
    
    fileprivate func adjustMiddleConstraint(to constant: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.middleConstraint.constant = constant
        }, completion: nil)
    }
    
}
