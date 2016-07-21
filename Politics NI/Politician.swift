//
//  Politician.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//


class Politician {
    var id:Int
    var name:String
    var constituency:String
    var party:String
    var imageURL:String
    var email:String
    var phoneNumber:String
    
    init(id: Int, name: String, constituency: String, party: String, imageURL: String, email: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.constituency = constituency
        self.party = party
        self.imageURL = imageURL
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
}
