//
//  PartyView.swift
//  Politics NI
//
//  Created by App Camp on 01/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

class PartyView {
    var issueDesc: String!
    var partyID: String!
    var view: String!
    var viewsrc: String!
    var issueID: String!
    
    init(issueID: String!, issueDesc: String!, partyID: String, view: String, viewsrc: String) {
        self.issueID = issueID
        self.issueDesc = issueDesc
        self.partyID = partyID
        self.view = view
        self.viewsrc = viewsrc
    }
    
    
}
