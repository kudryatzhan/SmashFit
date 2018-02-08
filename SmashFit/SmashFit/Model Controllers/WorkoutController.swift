//
//  WorkoutController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/7/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation
import Firebase

class WorkoutController {
    
    static let shared = WorkoutController()
    
    // save workout to firebase
    func saveToFirebase(workout: Workout) {
        guard let currentUser = currentLoggedInUser else { return }
        let allGymsRef = Database.database().reference(withPath: "gyms")
        let gymRef = allGymsRef.child(currentUser.gymName)
        let allWorkoutsRef = gymRef.child("workouts")
        let workoutRef = allWorkoutsRef.child(dateIdentifierFormatter.string(from: Date()))
        let values: [String: Any] = ["type": workout.type,
                                     "description": workout.description,
                                     "dateAdded": workout.dateAddedAsString]
        workoutRef.setValue(values)
    
    }
    
    
}
