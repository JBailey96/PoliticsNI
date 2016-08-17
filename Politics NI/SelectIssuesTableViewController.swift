    //
//  SelectIssuesTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 03/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
class SelectIssuesTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var rootRef: FIRDatabaseReference!
    var partyViews = [PartyView]()
    var issues = [Issue]()
    var issue:Issue!
    var partyViewsCollect = [PartyView]()
    
    var firstAttempt = true
    
    @IBOutlet weak var backItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstAttempt = true
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        rootRef = FIRDatabase.database().reference()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 90
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
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
         return issues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! IssuesCellViewController
        
             let entry = issues[indexPath.row]
             cell.issueLabel.text = entry.desc
             cell.userInteractionEnabled = true
             cell.issueLabel.textColor = UIColor.blackColor()
             cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToIssues" {
            let issueIndex = tableView.indexPathForSelectedRow?.row
            for view in partyViews {
                if (issues[issueIndex!].id == view.issueID) {
                    partyViewsCollect.append(view)
                }
            }
            let desView = segue.destinationViewController as! UserResponseViewController
            desView.partyViews = partyViewsCollect
            partyViewsCollect.removeAll()
        }
        }
    
    
    func compareIssues() {
        let userResponded = userUtility.issues
        if (!userResponded.isEmpty) && (!issues.isEmpty) {
            for (usrResindex, usrRes) in userResponded.enumerate() {
                for (issIndex, issue) in issues.enumerate() {
                    if usrRes.id == issue.id {
                        print("in")
                        print(issues[issIndex].desc)
                        issues.removeAtIndex(issIndex)
                    }
                }
            }
        }
        firstAttempt = false
        self.tableView.reloadData()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There are no more issues to reply to."
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
