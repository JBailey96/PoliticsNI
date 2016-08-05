//
//  SideMenuTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 27/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//
import Firebase

class SideMenuTableViewController: UITableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "logoutSegue") {
           try! FIRAuth.auth()?.signOut()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
