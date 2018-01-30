//
//  SettingsViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 1/30/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = "Welcome, Mr. \(currentUser.displayName ?? "unknown")"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // FIXME: - Sample button calling it, change the design of the whole view
    @IBAction func logout(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            // AlertController telling about a Logout Error
            let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        // Present the welcome view
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
