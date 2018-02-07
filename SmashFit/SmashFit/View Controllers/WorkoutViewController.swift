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
    @IBOutlet weak var wodTextView: UITextView!
    
    // MARK: - Properties
    let workoutReference = Database.database().reference(withPath: "workouts")
    let usersReference = Database.database().reference(withPath: "users")
    var isAthleteLoggedIn = true // Athlete or Coach

    
    // MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Check if user is athlete or a coach
        usersReference.child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
            
            if let values = snapshot.value as? [String: Any] {
                self.isAthleteLoggedIn = values["isAthlete"] as! Bool
                self.wodTextView.isEditable =  self.isAthleteLoggedIn ? false : true
            }
        }
        
        //  Get today's workout
        workoutReference.child("060218").observe(.value) { (snapshot) in
            
            let values = snapshot.value as! [String: Any]
            let workout = values["workout"] as! String
            self.wodTextView.text = workout
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
          setTodaysDate()
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { print("TextField cannot be empty"); return}
        
        let todaysWorkoutRef = self.workoutReference.child("060218")
        let values: [String: Any] = ["type": "metcon",
                                     "workout": text]
        todaysWorkoutRef.setValue(values)
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
}
