//
//  Party.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

class Party  {
    var id: String
    var name:String
    var logo:String
    var webLink: String
    var twitterLink:String
    var phoneNum: String
    var email: String
    
    init(id: String, name: String, logo: String, webLink: String, twitterLink: String, phoneNum: String, email: String)
    {
        self.id = id
        self.name = name
        self.logo = logo
        self.webLink = webLink
        self.twitterLink = twitterLink
        self.phoneNum = phoneNum
        self.email = email
    }
    

    
    
}
