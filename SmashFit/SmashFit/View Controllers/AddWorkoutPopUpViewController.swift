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
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var addWODLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bottomVCConstraint: NSLayoutConstraint!
    @IBOutlet weak var wodLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    let dropDown = DropDown()
    weak var delegate: WodDescriptionTextViewDelegate?
    
    // MARK: - IBActions
    @IBAction func saveWOD(_ sender: UIButton) {
        if let workoutText = wodDescriptionTextView.text, !workoutText.isEmpty, workoutText != "Please enter wod decription here...",
            let workoutType = typeButton.currentTitle, workoutType != "Choose WOD type..." {
            
            delegate?.wodTextViewDidEndEditig(with: workoutText)
            
            // Save workout to database
            let workout = Workout(type: workoutType, description: workoutText, dateAdded: Date(), dateAddedAsString: dateIdentifierFormatter.string(from: Date()))
            WorkoutController.shared.saveToFirebase(workout: workout)
            
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please make sure you choose workout type, and provide description below.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseTypeButtonTapped(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        wodDescriptionTextView.resignFirstResponder()
    }
    
    // MARK: - Lifecycle functions
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
        
        // Send notifications when keyboard status change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Please enter wod decription here..." {
            textView.text = ""
        }
        
    }
    
    // MARK: - Helper Methods
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        adjustTopConstraintTo(topConstant: 30, bottomConstant: keyboardFrame.height, leadingConstant: 40)
        
        self.addWODLabel.isHidden = true
        self.typeLabel.isHidden = true
        self.typeButton.isHidden = true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustTopConstraintTo(topConstant: 136, bottomConstant: 69, leadingConstant: 20)
        self.addWODLabel.isHidden = false
        self.typeLabel.isHidden = false
        self.typeButton.isHidden = false
    }
    
    fileprivate func adjustTopConstraintTo(topConstant: CGFloat, bottomConstant: CGFloat, leadingConstant: CGFloat) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.wodLeadingConstraint.constant = leadingConstant
            self.topConstraint.constant = topConstant
            self.bottomVCConstraint.constant = bottomConstant
        }, completion: nil)
    }
}
