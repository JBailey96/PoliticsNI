//
//  PartyTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 28/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//
import Firebase

class PartyTableViewController: UITableViewController {
    lazy var partiesRef = FIRDatabase.database().reference().child("parties").child("party")
    var parties = [Party]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 90
            self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
        loadParties()
    }
    
    func loadParties() {
        
        partiesRef.keepSynced(true)
            partiesRef.observeEventType(.Value, withBlock: { snapshot in
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    
                    let id = childSnapshot.value!.objectForKey("PartyOrganisationId") as! String
                    let email = childSnapshot.value!.objectForKey("email") as! String
                    let logo = childSnapshot.value!.objectForKey("logo") as! String
                    let name = childSnapshot.value!.objectForKey("name") as! String
                    let phoneNum = childSnapshot.value!.objectForKey("phoneNum") as! String
                    let webLink = childSnapshot.value!.objectForKey("webLink") as! String
                    let twitter = childSnapshot.value!.objectForKey("twitter") as! String
                    let party = Party(id: id, name: name, logo: logo, webLink: webLink, twitterLink: twitter, phoneNum: phoneNum, email: email)
                    self.parties.append(party)
                }
            self.tableView.reloadData()
            })
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PartyCellViewController
        let entry = parties[indexPath.row]
        let image = UIImage(named: entry.logo)
        cell.partyLogo.image = image
        cell.partyName.text = entry.name
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToPartyProfile" {
        let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
        let desView: PartyProfileVIewController = tabBarC.viewControllers?.first as! PartyProfileVIewController
        let des2View: PartyTwitterController = tabBarC.viewControllers?[1] as! PartyTwitterController
        let des3View: PartyTableIssuesViewController = tabBarC.viewControllers?[2] as! PartyTableIssuesViewController
        let partyIndex = tableView.indexPathForSelectedRow?.row
        desView.currentParty = parties[partyIndex!]
        des2View.currentParty = parties[partyIndex!]
        des3View.currentParty = parties[partyIndex!]
        }

    
}
}