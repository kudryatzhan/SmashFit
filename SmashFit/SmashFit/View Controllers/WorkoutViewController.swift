//
//  WorkoutViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/5/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class WorkoutViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wodTextField: UITextView!
    
    // MARK: - Properties
    let workoutReference = Database.database().reference(withPath: "workouts")
    let usersReference = Database.database().reference(withPath: "users")
    var isAthleteLoggedIn = true
    
    // MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersReference.child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
            
            let values = snapshot.value as! [String: Any]
            self.isAthleteLoggedIn = values["isAthlete"] as! Bool
        }
        
        workoutReference.child("060218").observe(.value) { (snapshot) in
            
            let values = snapshot.value as! [String: Any]
            let workout = values["workout"] as! String
            self.wodTextField.text = workout
        }
        
        wodTextField.isEditable =  isAthleteLoggedIn ? false : true
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { print("TextField cannot be empty"); return}
        
        let todaysWorkoutRef = self.workoutReference.child("060218")
        let values: [String: Any] = ["type": "metcon",
                                     "workout": text]
        todaysWorkoutRef.setValue(values)
    }
}
