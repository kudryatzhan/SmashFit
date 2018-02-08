//
//  WorkoutViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/5/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

class WorkoutViewController: UIViewController, UITextViewDelegate, WodDescriptionTextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wodTextView: UITextView!
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var workoutTypeLabel: UILabel!
    
    // MARK: - Properties
    let workoutReference = Database.database().reference(withPath: "workouts")
    let usersReference = Database.database().reference(withPath: "users")
    var isAthleteLoggedIn = true // Athlete or Coach
    
    
    // MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user is athlete or a coach
        usersReference.child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
            if let values = snapshot.value as? [String: Any],
                let isAthlete = values["isAthlete"] as? Bool {
                
                self.isAthleteLoggedIn = isAthlete
                self.wodTextView.isEditable =  self.isAthleteLoggedIn ? false : true
                self.addWorkoutButton.isHidden = self.isAthleteLoggedIn ? true : false
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTodaysDate()
        
        usersReference.child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
            
            if let values = snapshot.value as? [String: Any],
                let email = values["email"] as? String,
                let gym = values["gym"] as? String,
                let isAthlete = values["isAthlete"] as? Bool,
                let name = values["name"] as? String,
                let uid = values["uid"] as? String {
                
                // set currentLoggedInUser
                currentLoggedInUser = User(uid: uid, name: name, email: email, gymName: gym, isAthlete: isAthlete)
                
                //  set today's workout
                guard let currentUser = currentLoggedInUser else { print("currentLoggedInUser user is nil"); return }
                let allGymsRef = Database.database().reference(withPath: "gyms")
                let gymRef = allGymsRef.child(currentUser.gymName)
                let allWorkoutsRef = gymRef.child("workouts")
            
                allWorkoutsRef.child(dateIdentifierFormatter.string(from: Date())).observe(.value) { (snapshot) in
                    if let values = snapshot.value as? [String: Any],
                        let workout = values["description"] as? String,
                        let type = values["type"] as? String {
                        
                        self.wodTextView.text = workout
                        self.workoutTypeLabel.text = type
                    }
                }
            }
        }
        
        
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { print("TextField cannot be empty"); return}
        
        let todaysWorkoutRef = self.workoutReference.child("060218")
        let values: [String: Any] = ["type": "metcon",
                                     "workout": text]
        todaysWorkoutRef.setValue(values)
    }
    
    // MARK: - WodDescriptionTextViewDelegate
    func wodTextViewDidEndEditig(with text: String) {
        wodTextView.text = text
    }
    
    // MARK: - Helper methods
    // Set date
    func setTodaysDate() {
        let calendar = Calendar.current
        let date = Date()
        
        let dayOfTheWeekAsInt = calendar.component(.weekday, from: date)
        var dayOfTheWeekAsString = ""
        
        switch dayOfTheWeekAsInt {
        case 1:
            dayOfTheWeekAsString = "Sunday"
        case 2:
            dayOfTheWeekAsString = "Monday"
        case 3:
            dayOfTheWeekAsString = "Tuesday"
        case 4:
            dayOfTheWeekAsString = "Wednesday"
        case 5:
            dayOfTheWeekAsString = "Thursday"
        case 6:
            dayOfTheWeekAsString = "Friday"
        case 7:
            dayOfTheWeekAsString = "Saturday"
        default:
            dayOfTheWeekAsString = ""
        }
        
        weekDayLabel.text = dayOfTheWeekAsString
        dateLabel.text = dateFormatter.string(from: date)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddWorkoutVC" {
            guard let destionation = segue.destination as? AddWorkoutPopUpViewController else { return }
            destionation.delegate = self
        }
    }
}
