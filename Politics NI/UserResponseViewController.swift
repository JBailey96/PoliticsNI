//
//  UserResponseViewController.swift
//  Politics NI
//
//  Created by App Camp on 02/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
class UserResponseViewController: UIViewController {
    var partyViews: [PartyView]!
    var agreeViews = [PartyView]()
    var disagreeViews = [PartyView]()
    var unsureViews = [PartyView]()
    var neutralViews = [PartyView]()
    
    var dictionaryPartyViews = [[String: String!]]()
    
    let ref = FIRDatabase.database().reference()
    var selectIssue: Issue!
    var count = 0
    
    @IBOutlet weak var issueCountNotif: UILabel!
    @IBOutlet weak var viewDesc: UILabel!
    @IBOutlet weak var issue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count = 0
        viewDesc.text = partyViews[count].view
        issue.text = partyViews[count].issueDesc
        updateCount()
    }
    
    @IBAction func agree(sender: AnyObject) {
        agreeViews.append(partyViews[count])
        nextQuestion()
        updateCount()
    }
    
    @IBAction func disagree(sender: AnyObject) {
        disagreeViews.append(partyViews[count])
        nextQuestion()
        updateCount()
    }
    
    @IBAction func neitherAgree(sender: AnyObject) {
        neutralViews.append(partyViews[count])
        nextQuestion()
        updateCount()
    }
    
    @IBAction func unsure(sender: AnyObject) {
        unsureViews.append(partyViews[count])
        nextQuestion()
        updateCount()
    }
    
    func nextQuestion() {
        count = count + 1
        if (count < partyViews.count) {
            viewDesc.text = partyViews[count].view
            issue.text = partyViews[count].issueDesc
        } else {
            setUserIssues()
            performSegueWithIdentifier("returnToIssues", sender: self)
        }
    }
    
    func updateCount() {
        let countCurrent = String(count+1)
        issueCountNotif.text = "Issue " + countCurrent + "/" + String(partyViews.count)
    }
    
    func setUserIssues() {
        let user = FIRAuth.auth()?.currentUser
        let issueWrite = ["issueDesc": partyViews[0].issueDesc, "issueID": partyViews[0].issueID]
        self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).setValue(issueWrite)
        
       
        for view in agreeViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            saveUserStat("Agree", issueID: view.issueID, partyID: view.partyID)
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Agree").setValue(dictionaryPartyViews)
                dictionaryPartyViews.removeAll()
        
        for view in disagreeViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Disagree").setValue(dictionaryPartyViews)
            dictionaryPartyViews.removeAll()
        
        for view in unsureViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Unsure").setValue(dictionaryPartyViews)
            dictionaryPartyViews.removeAll()
        
        for view in neutralViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Neutral").setValue(dictionaryPartyViews)
            dictionaryPartyViews.removeAll()
            userUtility.getUserIssues()
    }
    
    func saveUserStat(opinion: String, issueID: String, partyID: String) {
        let ref = self.ref.child("parties").child("issues").child("issue")
        var ref2: FIRDatabaseReference!
        var childSnapshot: FIRDataSnapshot!
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                if (child.value!.objectForKey("id") as! String! == issueID) {
                childSnapshot = snapshot.childSnapshotForPath(child.key).childSnapshotForPath("partyViews")
                ref2 = ref2.child(child.key).child("partyViews")
                }
                for child in childSnapshot.children {
                    if (snapshot.value!.objectForKey("partyID") as! String? == partyID) {
                        ref2.child(child.key).child(opinion).setValue("1")
                    }
                }
            }
        })
    }
    }

