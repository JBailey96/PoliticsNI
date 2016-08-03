//
//  User.swift
//  Politics NI
//
//  Created by App Camp on 25/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation

class User {
    var fullName: String
    var birthDay: String
    var gender: String
    var constituency: String
    
    init(fullName: String, birthDay: String, gender: String, constituency: String) {
        self.fullName = fullName
        self.birthDay = birthDay
        self.gender = gender
        self.constituency = constituency
    }
}
