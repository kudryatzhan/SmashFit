//
//  Helpers.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/6/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation
import Firebase

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy"
    return formatter
}()

//  workout date identifier for Firebase
let dateIdentifierFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMddyyyy"
    return formatter
}()

// currentLoggedInUser
var currentLoggedInUser: User?

// all gym list
var allGymsList: [String] = []
