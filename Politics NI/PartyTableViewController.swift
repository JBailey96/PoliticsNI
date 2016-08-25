//
//  PartyTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 28/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//
import Firebase

class PartyTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    lazy var partiesRef = FIRDatabase.database().reference().child("parties").child("party")
    var parties = [Party]()
    var display = false
    var firstAttempt = true
    var currentParty: Party!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        firstAttempt = true
        
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
        self.firstAttempt = false
        self.tableView.reloadData()
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (display) && (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("partyInfoCell", forIndexPath: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PartyCellViewController
        
        var entry: Party!
        if (display) {
            entry = parties[indexPath.row-1]
        } else {
            entry = parties[indexPath.row]
        }
        
        let image = UIImage(named: entry.logo)
        cell.partyLogo.image = image
        cell.partyName.text = entry.name
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (display) {
            return parties.count + 1
        } else {
            return parties.count
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToPartyProfile" {
            let path = tableView.indexPathForSelectedRow
            let paths = path?.row
            if (display) {
                self.currentParty = parties[paths!-1]
            } else {
                self.currentParty = parties[paths!]
            }
            
        let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
        let desView: PartyProfileVIewController = tabBarC.viewControllers?.first as! PartyProfileVIewController
        let des3View: PartyTableIssuesViewController = tabBarC.viewControllers?[1] as! PartyTableIssuesViewController
        desView.currentParty = currentParty
        des3View.currentParty = currentParty
        }
}
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There was a problem loading the political parties. Could there be an issue with your internet?"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "group")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (display) && indexPath.row == 0 {
            return 118
        }
        return 90
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if (firstAttempt) {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func infoToggle(sender: AnyObject) {
        if (display) {
            display = false
        } else {
            display = true
        }
        tableView.reloadData()
    }
    
}