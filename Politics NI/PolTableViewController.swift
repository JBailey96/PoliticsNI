//
//  PolTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 21/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit
import Firebase

class PolTableViewController:  UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    lazy var politciansArr = DatabaseUtility.loadAllMembers() //array of all the politicians
    var myPol = [Politician]() //array of your politicians
    lazy var userConstituency = userUtility.user.constituency //get current user's constituency
    var currentPol: Politician?
    var indexPathPol: Int?
    var firstRun = false
    var display = false

    
    
    @IBOutlet weak var constituencyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        //finds your constituency's politicians
        for member in politciansArr {
            if userConstituency == member.constituency {
                myPol.append(member)
            }
        }
        
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        //sets up table view properties
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 90
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.title = "Politicians in my Area"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (firstRun) {
            return myPol.count + 1
        } else {
            return myPol.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (firstRun == true) {
            let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) 
            firstRun = false
            display = true
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PolCellViewController
        
        var entry: Politician!
        
        if (display) {
            entry = myPol[indexPath.row-1]
        } else {
            entry = myPol[indexPath.row]
        }
    
        let url = NSURL(string:entry.imageURL)
        let dat = NSData(contentsOfURL: url!)
    
        let image = UIImage(data: dat!)
        
        cell.profilePic.image = image
        cell.nameLabel.text = entry.firstName + " " + entry.lastName
        cell.constituencyLabel.text = entry.party
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (display) {
            self.currentPol = myPol[indexPath.row-1]
        } else {
            self.currentPol = myPol[indexPath.row]
        }
    }
    
    //segues to politician profile
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToProfile" {
            
            let path = tableView.indexPathForSelectedRow
            let paths = path?.row
            
            if (display) {
                self.currentPol = myPol[paths!-1]
            } else {
                self.currentPol = myPol[paths!]
            }
            
            //let des2View = PolTwitterViewController()
            //des2View.currentPol = myPol[polIndex!]
//            
//            let mlaRef = FIRDatabase.database().reference().child("MLAContact")
//            mlaRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//                    print(snapshot.value)
//                    print(self.currentPol?.id)
//                    for child in snapshot.children {
//                        let childSnapshot = snapshot.childSnapshotForPath(child.key)
//                        if (self.currentPol!.id == childSnapshot.value!.objectForKey("id")?.stringValue) {
//                            let phoneNum = childSnapshot.value!.objectForKey("Telephone Number")?.stringValue
//                            self.currentPol?.phoneNumber = phoneNum!
//                            
//                            let email = childSnapshot.value!.objectForKey("Email contact address") as! String
//                            //print(email)
//                            self.currentPol?.email = email
//                            
//                            let twitter = childSnapshot.value!.objectForKey("Twitter") as! String
//                            self.currentPol?.twitter = twitter
//                            
//                            let altEmail = childSnapshot.value!.objectForKey("Alternative Email contact") as! String
//                            self.currentPol?.altEmail = altEmail
//                        }
//                }
//                })
                print("we did it")
                let desView = (segue.destinationViewController as! PoliticianProfileViewController)
                desView.currentPol = self.currentPol
        }
        
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There was a problem loading your local politicians. Could there be an issue with your internet?"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    @IBAction func infoToggle(sender: AnyObject) {
        if (display) {
            firstRun = false
            display = false
        } else {
            firstRun = true
        }
        tableView.reloadData()
    }
    
}