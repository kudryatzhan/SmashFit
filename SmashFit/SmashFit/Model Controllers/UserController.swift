//
//  UserController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/6/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let shared = UserController()
    
    // save user to firebase
    func saveToFirebase(user: User) {
        let allUsersRef = Database.database().reference(withPath: "users")
        let userRef = allUsersRef.child(user.uid)
        let values: [String: Any] = ["name": user.name,
                                     "email": user.email,
                                     "gym": user.gymName,
                                     "uid": user.uid,
                                     "isAthlete": user.isAthlete]
        userRef.setValue(values)
        
        // Check if gym is already in the list to avoid recreating it
        if !user.isAthlete {
            let allGymsRef = Database.database().reference(withPath: "gyms")
            allGymsRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild(user.gymName) {
                    print("already exists")
                } else {
                    // save gym to firebase
                    let gymRef = allGymsRef.child(user.gymName)
                    let values: [String: Any] = ["name": user.gymName]
                    gymRef.setValue(values)
                }
            }
        }
    }
}
