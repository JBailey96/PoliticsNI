//
//  userUtility.swift
//  Politics NI
//
//  Created by App Camp on 27/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class userUtility {
    static let rootRef = FIRDatabase.database().reference()
    static var authData = FIRAuth.auth()?.currentUser?.uid
    static var user: User = User(fullName: "", birthDay: "", gender: "", constituency: "") //current user
   
    static var issues =  [Issue]()
    static var agreeViews = [PartyView]()
    static var disagreeViews = [PartyView]()
    static var unsureViews = [PartyView]()
    static var neutralViews = [PartyView]()
    
    //gets all the users information and saves it as the current user variable
    class func getUserInfo() {
        let userRef = rootRef.child("users")
        let uidRef = userRef.child(authData!)
        uidRef.observeEventType(.Value, withBlock: { snapshot in
            let constituency = snapshot.value?.objectForKey("constituency") as! String
            let dob = snapshot.value?.objectForKey("dob") as! String
            let fullName = snapshot.value?.objectForKey("full_name") as! String
            let gender = snapshot.value?.objectForKey("gender") as! String
            user = User(fullName: fullName, birthDay: dob, gender: gender, constituency: constituency)
            }, withCancelBlock:  { error in
                print(error.description)
        })
}
    class func getUserIssues() {
        let issueResp = rootRef.child("users").child(authData!).child("issueResponses")
        
        issueResp.observeEventType(.Value, withBlock: { snapshot in
            issues.removeAll()
            agreeViews.removeAll()
            disagreeViews.removeAll()
            neutralViews.removeAll()
            unsureViews.removeAll()
            
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let issueDesc = childSnapshot.value?.objectForKey("issueDesc") as! String
                let issueID = childSnapshot.value?.objectForKey("issueID") as! String
                let issue = Issue(desc: issueDesc, id: issueID)
                issues.append(issue)
                
                var viewsChild = childSnapshot.childSnapshotForPath("partyViews").childSnapshotForPath("Agree")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    agreeViews.append(partyView)
                    }
                
                viewsChild = childSnapshot.childSnapshotForPath("partyViews").childSnapshotForPath("Disagree")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    disagreeViews.append(partyView)
                }
                
                viewsChild = childSnapshot.childSnapshotForPath("partyViews").childSnapshotForPath("Neutral")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    neutralViews.append(partyView)
                }
                
                viewsChild = childSnapshot.childSnapshotForPath("partyViews").childSnapshotForPath("Unsure")
                for child in viewsChild.children {
                    let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                    let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                    let view = childSnapshot.value!.objectForKey("view") as! String
                    let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                    let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    unsureViews.append(partyView)
                }
            }

            }, withCancelBlock:  { error in
                print(error.description)
        })
        
    }
}