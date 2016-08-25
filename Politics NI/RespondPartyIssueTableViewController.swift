//
//  RespondPartyIssueTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 09/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
import SVProgressHUD

class RespondPartyIssueTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var issues = [Issue]()
    var partyViews = [PartyView]()
    var issue: Issue!
    var respondIssues = [Issue]()
    var partyViewsCollect = [PartyView]()
    
    
    var agreeViews = [PartyView]()
    var disagreeViews = [PartyView]()
    var unsureViews = [PartyView]()
    var neutralViews = [PartyView]()
    
    var firstAttempt = true
    
    override func viewDidLoad() {
        firstAttempt = true
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 122
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        loadPartyViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        compareIssues()
    }
    
    func loadPartyViews() {
        let issuesRef = FIRDatabase.database().reference().child("parties").child("issues").child("issue")
        
        self.issues.removeAll()
        self.partyViews.removeAll()
        issuesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let desc = childSnapshot.value!.objectForKey("desc") as! String
                let id = childSnapshot.value!.objectForKey("id") as! String
                self.issue = Issue(desc: desc, id: id)
                self.issues.append(self.issue)
                
                
                let viewsChild = childSnapshot.childSnapshotForPath("partyViews")
                for child in viewsChild.children {
                    let test = viewsChild.childSnapshotForPath(child.key)
                    let view = test.value!.objectForKey("view") as! String
                    let viewsrc = test.value!.objectForKey("viewsrc") as! String
                    let partyID = test.value!.objectForKey("partyID") as! String
                    let partyView = PartyView(issueID: self.issue.id, issueDesc: self.issue!.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                    self.partyViews.append(partyView)
                }
            }
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return respondIssues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! RespondPartyIssuesCellViewController
        
        
        if (!respondIssues.isEmpty) {
            let entry = respondIssues[indexPath.row]
            cell.issue.text = entry.desc
            cell.userInteractionEnabled = true
            cell.issue.textColor = UIColor.blackColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.issue.text = "There are no more issues."
            cell.userInteractionEnabled = false
            cell.issue.textColor = UIColor.grayColor()
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    func compareIssues() {
        var currentIssueResp = [Issue]()
        let userResponded = userUtility.issues
        if (!userResponded.isEmpty) && (!issues.isEmpty) {
        for (issIndex, issue) in issues.enumerate() {
            for (usrResindex, usrRes) in userResponded.enumerate() {
                    if usrRes.id == issue.id {
                        print("in")
                        print(issues[issIndex].desc)
                        currentIssueResp.append(issue)
                    }
            }
            }
        }
        self.respondIssues = currentIssueResp
        firstAttempt = false
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToViews" {
            let issueIndex = tableView.indexPathForSelectedRow?.row
            for view in partyViews {
                if (respondIssues[issueIndex!].id == view.issueID) {
                    partyViewsCollect.append(view)
                }
            }
            let desView = segue.destinationViewController as! RespondPartyViewsTableViewController
            desView.partyViews = partyViewsCollect
            partyViewsCollect.removeAll()
        }
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You have not responded to any issues."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }


    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if (firstAttempt) {
            return false
        } else {
            return true
        } 
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "issuesresponses")!
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            self.deleteIssue(indexPath.row)
            }
        }
    }
    
    func deleteIssue(index: Int) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            SVProgressHUD.show()
            let uidRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
            let issueResp = uidRef.child("issueResponses")
            var agreeinBlock =  [PartyView]()
            var disagreeinBlock = [PartyView]()
            var unsureinBlock = [PartyView]()
            var neutralinBlock = [PartyView]()
            
            let semaphore = dispatch_semaphore_create(0)
            issueResp.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    var viewsChild = snapshot.childSnapshotForPath(self.respondIssues[index].id).childSnapshotForPath("partyViews").childSnapshotForPath("Agree")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: self.respondIssues[index].id, issueDesc: self.respondIssues[index].desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        agreeinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(self.respondIssues[index].id).childSnapshotForPath("partyViews").childSnapshotForPath("Disagree")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: self.respondIssues[index].id, issueDesc: self.respondIssues[index].desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        disagreeinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(self.respondIssues[index].id).childSnapshotForPath("partyViews").childSnapshotForPath("Neutral")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: self.respondIssues[index].id, issueDesc: self.respondIssues[index].desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        neutralinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(self.respondIssues[index].id).childSnapshotForPath("partyViews").childSnapshotForPath("Unsure")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: self.respondIssues[index].id, issueDesc: self.respondIssues[index].desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        unsureinBlock.append(partyView)
                    }
                
                self.agreeViews =  agreeinBlock
                self.disagreeViews = disagreeinBlock
                self.unsureViews = unsureinBlock
                self.neutralViews = neutralinBlock
                
                for view in self.agreeViews {
                    self.updateStats(view, opinion: "Agree")
                }
                for view in self.disagreeViews {
                    self.updateStats(view, opinion: "Disagree")
                }
                for view in self.unsureViews {
                    self.updateStats(view, opinion: "Unsure")
                }
                for view in self.neutralViews {
                    self.updateStats(view, opinion: "Neutral")
                }
                
                dispatch_semaphore_signal(semaphore)
                }, withCancelBlock:  { error in
                    print(error.description)
                }
            )
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            let ref = FIRDatabase.database().reference()
            let user = FIRAuth.auth()?.currentUser
            ref.child("users").child(user!.uid).child("issueResponses").child(self.respondIssues[index].id).removeValue()
            self.respondIssues.removeAtIndex(index)
            userUtility.getUserIssues()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
            SVProgressHUD.dismiss()

        }
    }
    
    func updateStats(view: PartyView, opinion: String) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
        let ref = FIRDatabase.database().reference()
        let statRef = ref.child("Stats")
        let semaphore = dispatch_semaphore_create(0)
        let semaphore1 = dispatch_semaphore_create(0)
        //            let semaphore2 = dispatch_semaphore_create(0)
        
        let viewStatRef = statRef.child(view.issueID).child(view.partyID).child(opinion)
        let userAge = userUtility.user.birthDay
        let userGender = userUtility.user.gender
        
        //            let userConstit = userUtility.user.constituency
        let ageRef = viewStatRef.child("Age").child(userAge)
        let genderRef = viewStatRef.child("Gender").child(userGender)
        //            let constitRef = viewStatRef.child("Constit").child(userConstit)
        
        
        ageRef.runTransactionBlock({
            (currentData:FIRMutableData!) in
            var value = currentData.value as? Int
            if (value == nil) {
                value = 0
            }
            currentData.value = value! - 1
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
            currentData.value = value! - 1
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
    }
    }
    }
