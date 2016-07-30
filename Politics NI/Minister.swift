//
//  Minister.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

class Minister: Politician {
    var department:String?
    var role:String?
    
    init(department: String, role: String, id: String, firstName: String, lastName: String, constituency: String, party: String, imageURL: String, email: String, phoneNumber: String, twitter: String, altEmail: String) {
        super.init(id: id, firstName: firstName, lastName: lastName, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber, twitter: twitter, altEmail: altEmail)
        self.department = department
        self.role = role
    }
    
    
}
