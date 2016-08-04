//
//  PartyEval.swift
//  Politics NI
//
//  Created by App Camp on 04/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

class PartyEval {
    var partyID: String!
    var score: Double!
    var numViewsAns: Double!
    var percent: Double!
    
    init(partyID: String!, score: Double!, numViewsAns: Double!) {
        self.partyID = partyID
        self.score = score
        self.numViewsAns = numViewsAns
    }
}
