//
//  Politician.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//


class Politician {
    var id:String
    var firstName:String
    var lastName: String
    var constituency:String
    var party:String
    var imageURL:String
    var email:String
    var altEmail:String
    var phoneNumber:String
    var twitter:String
    
    init(id: String, firstName: String, lastName: String, constituency: String, party: String, imageURL: String, email: String, phoneNumber: String, twitter: String, altEmail: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.constituency = constituency
        self.party = party
        self.imageURL = imageURL
        self.email = email
        self.phoneNumber = phoneNumber
        self.twitter = twitter
        self.altEmail = email
    }
    
}
