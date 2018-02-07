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
    
    let allWorkoutsRef = Database.database().reference(withPath: "workouts")
    
    // save workout to firebase
    func saveToFirebase(workout: Workout) {
        let workoutRef = allWorkoutsRef.child(workout.dateAddedAsString)
        let values: [String: Any] = ["type": workout.type,
                                     "description": workout.description,
                                     "dateAdded": workout.dateAdded]
    }
}
