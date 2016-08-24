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
   
    static var issues =  [Issue]() //all the issues in fb
    static var agreeViews = [PartyView]() //views the user agrees with
    static var disagreeViews = [PartyView]() //views the user disagrees with
    static var unsureViews = [PartyView]() //unsure
    static var neutralViews = [PartyView]() //neutral
    
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
    
    //gets all the user's issues from fb
    class func getUserIssues() {
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            
        let uidRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
        let issueResp = uidRef.child("issueResponses")
        var issuesinBlock = [Issue]()
        var agreeinBlock =  [PartyView]()
        var disagreeinBlock = [PartyView]()
        var unsureinBlock = [PartyView]()
        var neutralinBlock = [PartyView]()
        
        let semaphore = dispatch_semaphore_create(0)
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
            
            dispatch_semaphore_signal(semaphore)
            }, withCancelBlock:  { error in
                print(error.description)
        }

        )
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
    }
}