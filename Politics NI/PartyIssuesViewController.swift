//
//  PartyIssuesViewController.swift
//  Politics NI
//
//  Created by App Camp on 01/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//
import Firebase

class PartyIssuesViewController: UITableViewController {
    let issuesRef = FIRDatabase.database().reference().child("parties").child("issues").child("issue")
     var currentParty: Party!
    var issue: Issue!
    var partyViewsArray = [PartyView]()
   
    override func viewDidLoad() {
        //loadIssues()
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
//    func loadIssues() {
//        issuesRef.keepSynced(true)
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
//                    if (test.value!.objectForKey("partyID") as? String == self.currentParty?.id) {
//                        let view = test.value!.objectForKey("view") as! String
//                        let viewsrc = test.value!.objectForKey("viewsrc") as! String
//                        let partyView = PartyView(issueID: self.issue.id, issueDesc: self.issue!.desc, partyID: (self.currentParty?.id)!, view: view, viewsrc: viewsrc)
//                        self.partyViewsArray.append(partyView)
//                }
//                }
//            }
//            self.tableView.reloadData()
//        })
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyViewsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! PartyIssuesCellViewController
        let entry = partyViewsArray[indexPath.row]
        
        cell.partyView.text  = entry.view
        cell.partyViewSrc.text = entry.viewsrc
        return cell
    }

    
    

}
