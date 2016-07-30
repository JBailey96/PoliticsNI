//
//  Party.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

class Party  {
    var name:String
    var logo:String
    var image = [String]()
    var description: String
    var facebookLink: String
    var youtubeLink: String
    var webLink: String
    var twitterLink:String
    var phoneNum: String
    var email: String
    var policies: [(String,Int)]
    
    init(name: String, logo: String, image: [String], description: String, facebookLink: String, youtubeLink: String, webLink: String, twitterLink: String, phoneNum: String, email: String, policies: [(String,Int)]) {
        self.name = name
        self.logo = logo
        self.image = image
        self.description = description
        self.facebookLink = facebookLink
        self.youtubeLink = youtubeLink
        self.webLink = webLink
        self.twitterLink = twitterLink
        self.phoneNum = phoneNum
        self.policies = policies
        self.email = email
    }
    

    
    
}
