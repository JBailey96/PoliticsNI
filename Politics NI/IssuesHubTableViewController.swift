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
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        self.navigationController?.navigationBar.backItem?.title
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs

    }
    
    
}
