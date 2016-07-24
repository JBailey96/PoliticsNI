//
//  DatabaseUtility.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import SwiftyJSON
import Firebase
import FirebaseDatabase

class DatabaseUtility {
    
    class func loadAllMembers() -> [Politician] {
        var politiciansArr = [Politician]()
        
        let urlString = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllCurrentMembers"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                for item in json["AllMembersList"]["Member"].arrayValue {
                    //if item["ConstituencyName"].string == "North Down" {
                        //print(item["MemberFullDisplayName"].stringValue)
                    //
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
    
    class func getConstituencies() -> [[String: String]] {
        var constitArr = [[String: String]]()
        let urlString = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllConstituencies"
        
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                for item in json["AllConstituencies"]["Constituency"].arrayValue {
                    let cons = item["ConstituencyName"].stringValue
                    let consID = item["ConstituencyId"].stringValue
                    constitArr.append([cons: consID])
                    //print(cons)
                }
                return constitArr
            }
        }
        return constitArr
    }
    
    class func getParties() -> [String] {
        var partiesArr = [String]()
        let urlString = "http://data.niassembly.gov.uk/organisations_json.ashx?m=GetPartiesListCurrent"
        
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                for item in json["OrganisationsList"]["Organisation"].arrayValue {
                    let party = item["OrganisationName"].stringValue
                    partiesArr.append(party)
                    //print(party)
                }
                return partiesArr
            }
        }
        return partiesArr
    }
    
    class func getConstituency(lat: String, long: String) -> String {
        var constit:String = ""
        var uri:String = ""
        let urlString = "http://uk-postcodes.com/postcode/nearest?lat=" + lat + "&lng=" + long + "&miles=0.2)]&format=json"
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                    uri = json["uri"].stringValue + ".json"
            }
        }
        
        if let url = NSURL(string: uri) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                constit = json["administrative"]["constituency"]["title"].stringValue
            }
        }
        return constit
    }
    
    
    }

