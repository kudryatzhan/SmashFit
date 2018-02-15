//
//  AddNewGymTableViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/10/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class AddNewGymTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // MARK: - IBActions
    
    @IBAction func saveBarButtonItemPressed(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text, !name.isEmpty {
            allGymsList.append(name)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
