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
    
    let allUsersRef = Database.database().reference(withPath: "users")
    
    // save user to firebase
    func saveToFirebase(user: User) {
        let userRef = allUsersRef.child(user.uid)
        let values: [String: Any] = ["name": user.name,
                                     "email": user.email,
                                     "uid": user.uid,
                                     "isAthlete": user.isAthlete]
        userRef.setValue(values)
        
    }
}
