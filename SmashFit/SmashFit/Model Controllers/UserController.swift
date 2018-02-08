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
        
        if user.isAthlete == false {
            // save gyms to firebase
            let allGymsRef = Database.database().reference(withPath: "gyms")
            let gymRef = allGymsRef.child(user.gymName)
            let values: [String: Any] = ["name": user.gymName]
            gymRef.setValue(values)
        }
    }
}
