//
//  userUtility.swift
//  Politics NI
//
//  Created by App Camp on 27/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class userUtility {
    static var user: User = User(birthDay: "", gender: "", constituency: "") //current user
   
    static var issues =  [Issue]()
    static var agreeViews = [PartyView]()
    static var disagreeViews = [PartyView]()
    static var unsureViews = [PartyView]()
    static var neutralViews = [PartyView]()
    
    //gets all the users information and saves it as the current user variable
    class func getUserInfo() {
        let uidRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        uidRef.keepSynced(true)
        uidRef.observeEventType(.Value, withBlock: { snapshot in
            let constituency = snapshot.value?.objectForKey("constituency") as! String
            let dob = snapshot.value?.objectForKey("dob") as! String
            let gender = snapshot.value?.objectForKey("gender") as! String
            user = User(birthDay: dob, gender: gender, constituency: constituency)
            }, withCancelBlock:  { error in
                print(error.description)
        })
}
    class func getUserIssues() {
        let uidRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        let issueResp = uidRef.child("issueResponses")
        var issuesinBlock = [Issue]()
        var agreeinBlock =  [PartyView]()
        var disagreeinBlock = [PartyView]()
        var unsureinBlock = [PartyView]()
        var neutralinBlock = [PartyView]()
        
        issueResp.observeSingleEventOfType(.Value, withBlock: { snapshot in
      
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let issueDesc = childSnapshot.value?.objectForKey("issueDesc") as! String
                let issueID = childSnapshot.value?.objectForKey("issueID") as! String
                let issue = Issue(desc: issueDesc, id: issueID)
                issuesinBlock.append(issue)
                
                var viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Agree")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    agreeinBlock.append(partyView)
                    }
                
                viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Disagree")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    disagreeinBlock.append(partyView)
                }
                
                viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Neutral")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    neutralinBlock.append(partyView)
                }
                
                viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Unsure")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    unsureinBlock.append(partyView)
                }
            }
            self.issues = issuesinBlock
            self.agreeViews =  agreeinBlock
            self.disagreeViews = disagreeinBlock
            self.unsureViews = unsureinBlock
            self.neutralViews = neutralinBlock
            }, withCancelBlock:  { error in
                print(error.description)
        }

        )
        
    }
}