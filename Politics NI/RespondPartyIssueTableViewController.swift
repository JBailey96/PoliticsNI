//
//  RespondPartyIssueTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 09/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class RespondPartyIssueTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var issues = [Issue]()
    var partyViews = [PartyView]()
    var issue: Issue!
    var respondIssues = [Issue]()
    var partyViewsCollect = [PartyView]()
    
    var firstAttempt = true
    
    override func viewDidLoad() {
        firstAttempt = true
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
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


}
