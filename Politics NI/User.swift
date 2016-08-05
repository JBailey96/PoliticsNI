//
//  User.swift
//  Politics NI
//
//  Created by App Camp on 25/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation

class User {
    var birthDay: String
    var gender: String
    var constituency: String
    
    init(birthDay: String, gender: String, constituency: String) {
        self.birthDay = birthDay
        self.gender = gender
        self.constituency = constituency
    }
}
