//
//  DatabaseUtility.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import SwiftyJSON

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
                    let id = item["PersonID"].intValue
                    let name = item["MemberFullDisplayName"].stringValue
                    let constituency = item["ConstituencyName"].stringValue
                    let party = item["PartyName"].stringValue
                    let imageURL = item["MemberImgUrl"].stringValue
                    let email = ""
                    let phoneNumber = ""
                    
                    let pol = Politician(id: id, name: name, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber)
                    
                    politiciansArr.append(pol)
                }
                return politiciansArr
            }
}
        return [Politician]()
}
}
