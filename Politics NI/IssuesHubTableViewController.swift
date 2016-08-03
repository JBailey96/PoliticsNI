//
//  IssuesHubTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 02/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class IssuesHubTableViewController: UITableViewController {
    var rootRef: FIRDatabaseReference!
    var partyViews = [PartyView]()
    var issue:Issue!
    
    override func viewDidLoad() {
        rootRef = FIRDatabase.database().reference()
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 122
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        loadPartyViews()
        
    }
    
//    func loadPartyViews() {
//        let issuesRef = FIRDatabase.database().reference().child("parties").child("issues").child("issue")
//        
//        issuesRef.observeEventType(.Value, withBlock: { snapshot in
//            for child in snapshot.children {
//                let childSnapshot = snapshot.childSnapshotForPath(child.key)
//                let desc = childSnapshot.value!.objectForKey("desc") as! String
//                let id = childSnapshot.value!.objectForKey("id") as! String
//                self.issue = Issue(desc: desc, id: id)
//                
//                let viewsChild = childSnapshot.childSnapshotForPath("partyViews")
//                for child in viewsChild.children {
//                    let test = viewsChild.childSnapshotForPath(child.key)
//                        let view = test.value!.objectForKey("view") as! String
//                        let viewsrc = test.value!.objectForKey("viewsrc") as! String
//                        let partyID = test.value!.objectForKey("partyID") as! String
//                        let partyView = PartyView(issueID: self.issue.id, issueDesc: self.issue!.desc, partyID: partyID, view: view, viewsrc: viewsrc)
//                        self.partyViews.append(partyView)
//                }
//            }
//        })
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if  segue.identifier == "selectIssues" {
//        }
//    }
    
    
    
}
