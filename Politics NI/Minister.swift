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
    
    init(department: String, role: String, id: Int, name: String, constituency: String, party: String, imageURL: String, email: String, phoneNumber: String) {
    super.init(id: id, name: name, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber)
        self.department = department
        self.role = role
    }
    
    
}
