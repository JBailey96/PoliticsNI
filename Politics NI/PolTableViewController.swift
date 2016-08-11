//
//  PolTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 21/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit

class PolTableViewController:  UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    lazy var politciansArr = DatabaseUtility.loadAllMembers() //array of all the politicians
    var myPol = [Politician]() //array of your politicians
    lazy var userConstituency = userUtility.user.constituency //get current user's constituency
    
    
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
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myPol.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PolCellViewController
        let entry = myPol[indexPath.row]
    
        let url = NSURL(string:entry.imageURL)
        let dat = NSData(contentsOfURL: url!)
    
        let image = UIImage(data: dat!)
        
        cell.profilePic.image = image
        cell.nameLabel.text = entry.firstName + " " + entry.lastName
        cell.constituencyLabel.text = entry.party
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(politciansArr[indexPath.row].firstName)
    }
    
    //segues to politician profile
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToProfile" {
            let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
            let desView: PoliticianProfileViewController = tabBarC.viewControllers?.first as! PoliticianProfileViewController
            let des2View: PolTwitterViewController = tabBarC.viewControllers?[1] as! PolTwitterViewController
            let polIndex = tableView.indexPathForSelectedRow?.row
            desView.currentPol = myPol[polIndex!]
            des2View.currentPol = myPol[polIndex!]
    }
}
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There was a problem loading your local politicians. Could there be an issue with your internet?"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    
}