//
//  AddWorkoutPopUpViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/6/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import DropDown

protocol WodDescriptionTextViewDelegate: class {
    func wodTextViewDidEndEditig(with text: String)
}

class AddWorkoutPopUpViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var wodDescriptionTextView: UITextView!
    
    // MARK: - Properties
    let dropDown = DropDown()
    weak var delegate: WodDescriptionTextViewDelegate?
    
    // MARK: - IBActions
    @IBAction func saveWOD(_ sender: UIButton) {
        delegate?.wodTextViewDidEndEditig(with: wodDescriptionTextView.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseTypeButtonTapped(_ sender: UIButton) {
        dropDown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        popUpView.layer.cornerRadius = 10
//        popUpView.layer.masksToBounds = true
        
        // Drop down menu setup
        dropDown.anchorView = typeButton
        dropDown.direction = .any
        dropDown.dataSource = ["AMRAP", "Bodyweight", "EMOM", "Endurance", "Girls", "Hero", "Tabata", "Time cap", "Weightlifting"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.typeButton.setTitle(item, for: .normal)
        }
    }
}
