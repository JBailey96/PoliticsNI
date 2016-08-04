//
//  DatabaseUtility.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import SwiftyJSON

class DatabaseUtility {
    

    // method for loading all the members of NI assembly
    class func loadAllMembers() -> [Politician] {
        var politiciansArr = [Politician]()
        
        let urlString = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllCurrentMembers"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                for item in json["AllMembersList"]["Member"].arrayValue {
                    let id = item["PersonId"].stringValue
                    let firstName = item["MemberFirstName"].stringValue
                    let lastName = item["MemberLastName"].stringValue
                    let constituency = item["ConstituencyName"].stringValue
                    let party = item["PartyName"].stringValue
                    let imageURL = item["MemberImgUrl"].stringValue
                    let email = ""
                    let phoneNumber = ""
                    let altEmail = ""
                    let twitter = ""
                    
                    let pol = Politician(id: id, firstName: firstName, lastName: lastName, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber, twitter: twitter, altEmail: altEmail)
                    politiciansArr.append(pol)
                }
                return politiciansArr
            }
}
        return [Politician]()
}

    
    //method for getting the name of a constiuency by searching through nia assembly API
    class func getConstituenciesName(conID: String) -> String {
        let urlString = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllConstituencies"
        let formatString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if let url = NSURL(string: formatString!) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                for item in json["AllConstituencies"]["Constituency"].arrayValue {
                    let cons = item["ConstituencyName"].stringValue
                    print(cons)
                    let consID = item["ConstituencyOnsCode"].stringValue
                    print(consID)
                    
                    if (conID == consID) {
                        print(cons)
                        return cons
                    }
                }
            }
        }
        return ""
    }
    
    //method for getting the constituency from the user's current location (longitude and latitude)
    class func getConstituency(lat: String, long: String) -> String {
        var constit:String = ""
        var uri:String = ""
        let urlString = "http://uk-postcodes.com/postcode/nearest?lat=" + lat + "&lng=" + long + "&miles=0.2)]&format=json"
        let formatString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if let url = NSURL(string: formatString!) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                    uri = json[0]["uri"].stringValue + ".json"
            }
        }
        

        
        let formatUri = uri.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        if let url = NSURL(string: formatUri!) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                constit = json["administrative"]["constituency"]["title"].stringValue
                let constitID = json["administrative"]["constituency"]["code"].stringValue
                constit = getConstituenciesName(constitID)
                print(constit)
                return constit
            }
        }
        return constit
    }
    
    class func getConstituencyPostCode(postCode: String) -> String {
        let uri = "http://uk-postcodes.com/postcode/" + postCode + ".json"
        let formatUri = uri.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var constit = ""
        
        if let url = NSURL(string: formatUri!) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                constit = json["administrative"]["constituency"]["title"].stringValue
                let constitID = json["administrative"]["constituency"]["code"].stringValue
                constit = getConstituenciesName(constitID)
                return constit
            }
        }
        return constit
    }
    
}