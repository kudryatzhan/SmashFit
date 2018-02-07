//
//  AddWorkoutPopUpViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/6/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class AddWorkoutPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    
    @IBAction func saveWOD(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
//        popUpView.layer.masksToBounds = true
    }
}
