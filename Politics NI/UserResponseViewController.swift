//
//  UserResponseViewController.swift
//  Politics NI
//
//  Created by App Camp on 02/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class UserResponseViewController: UITableViewController {
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
            saveUserStat(view, opinion: "Agree")
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Agree").setValue(dictionaryPartyViews)
                dictionaryPartyViews.removeAll()
        
        for view in disagreeViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            saveUserStat(view, opinion: "Disagree")
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Disagree").setValue(dictionaryPartyViews)
        dictionaryPartyViews.removeAll()
        
        for view in unsureViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            saveUserStat(view, opinion: "Unsure")
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Unsure").setValue(dictionaryPartyViews)
            dictionaryPartyViews.removeAll()
        
        for view in neutralViews {
            let partyView = ["partyID": view.partyID, "view": view.view, "viewsrc": view.viewsrc]
            saveUserStat(view, opinion: "Neutral")
            dictionaryPartyViews.append(partyView)
        }
            self.ref.child("users").child(user!.uid).child("issueResponses").child(partyViews[0].issueID).child("partyViews").child("Neutral").setValue(dictionaryPartyViews)
            dictionaryPartyViews.removeAll()
            userUtility.getUserIssues()
    }
    
    func saveUserStat(view: PartyView, opinion: String) {
        let statRef = self.ref.child("Stats")
         dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let semaphore = dispatch_semaphore_create(0)
            let semaphore1 = dispatch_semaphore_create(0)
            let semaphore2 = dispatch_semaphore_create(0)
                
            let viewStatRef = statRef.child(view.issueID).child(view.partyID).child(opinion)
            let userAge = userUtility.user.birthDay
            let userGender = userUtility.user.gender
            
            let userConstit = userUtility.user.constituency
            let ageRef = viewStatRef.child("Age").child(userAge)
            let genderRef = viewStatRef.child("Gender").child(userGender)
            let constitRef = viewStatRef.child("Constit").child(userConstit)

                
            ageRef.runTransactionBlock({
                    (currentData:FIRMutableData!) in
                    var value = currentData.value as? Int
                    if (value == nil) {
                        value = 0
                    }
                    currentData.value = value! + 1
                    return FIRTransactionResult.successWithValue(currentData)
                }, andCompletionBlock: {(error: NSError?, committed: Bool, snapshot: FIRDataSnapshot?) -> Void in
                    if error != nil {
                        print("Error: \(error!)")
                    }
                    if committed {
                        dispatch_semaphore_signal(semaphore)
                    }
                })

                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                    
                
                genderRef.runTransactionBlock({
                    (currentData:FIRMutableData!) in
                    var value = currentData.value as? Int
                    if (value == nil) {
                        value = 0
                    }
                    currentData.value = value! + 1
                    return FIRTransactionResult.successWithValue(currentData)
                    }, andCompletionBlock: {(error: NSError?, committed: Bool, snapshot: FIRDataSnapshot?) -> Void in
                        if error != nil {
                            print("Error: \(error!)")
                        }
                        if committed {
                            dispatch_semaphore_signal(semaphore1)
                        }
                    })
                
                dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER)
                
                    constitRef.runTransactionBlock({
                    (currentData:FIRMutableData!) in
                    var value = currentData.value as? Int
                    if (value == nil) {
                        value = 0
                    }
                    currentData.value = value! + 1
                    return FIRTransactionResult.successWithValue(currentData)
                        }, andCompletionBlock: {(error: NSError?, committed: Bool, snapshot: FIRDataSnapshot?) -> Void in
                            if error != nil {
                                print("Error: \(error!)")
                            }
                            if committed {
                                dispatch_semaphore_signal(semaphore2)
                            }
                        })
                
                dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER)
        
        
//            let ageSnapshot = snapshot.childSnapshotForPath(view.issueID).childSnapshotForPath(view.partyID).childSnapshotForPath(opinion).childSnapshotForPath("Age")
//            let ageRef = viewStatRef.child("Age").child(userAge)
//                if ageSnapshot.childSnapshotForPath(userAge).exists() {
//                let currentCountAge = ageSnapshot.value!.objectForKey(userAge) as? Int
//                let newCountAge = currentCountAge! + 1
//                ageRef.setValue(newCountAge)
//            } else {
//                ageRef.setValue(1)
//            }
//            
//            let genderSnapshot = snapshot.childSnapshotForPath(view.issueID).childSnapshotForPath(view.partyID).childSnapshotForPath(opinion).childSnapshotForPath("Gender")
//            let genderRef = viewStatRef.child("Gender").child(userGender)
//            if genderSnapshot.childSnapshotForPath(userGender).exists() {
//                let currentCountGender = genderSnapshot.value!.objectForKey(userGender) as? Int
//                let newCountGender = currentCountGender! + 1
//                genderRef.setValue(newCountGender)
//            } else {
//                genderRef.setValue(1)
//            }
//            
//            let constitSnapshot = snapshot.childSnapshotForPath(view.issueID).childSnapshotForPath(view.partyID).childSnapshotForPath(opinion).childSnapshotForPath("Constit")
//            let constitRef = viewStatRef.child("Constit").child(userConstit)
//            if  constitSnapshot.childSnapshotForPath(userConstit).exists() {
//                let currentCountConstit = constitSnapshot.value!.objectForKey(userConstit) as? Int
//                let newCountConstit = currentCountConstit! + 1
//                constitRef.setValue(newCountConstit)
//            } else {
//                constitRef.setValue(1)
//            }
                
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//                dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER)
//                dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER)
    }
}

}
