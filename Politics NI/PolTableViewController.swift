//
//  PolTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 21/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit

class PolTableViewController:  UITableViewController{
    let data = ViewController()
    @IBOutlet weak var constituencyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.rowHeight = 90
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.politiciansArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PolCellViewController
        let entry = data.politiciansArr[indexPath.row]
    
        let url = NSURL(string:entry.imageURL)
        let dat = NSData(contentsOfURL: url!)
    
        let image = UIImage(data: dat!)
        //cell.profilePic.layer.cornerRadius = 26
        //cell.profilePic.layer.masksToBounds = true
        
        cell.profilePic.image = image
        cell.nameLabel.text = entry.firstName + " " + entry.lastName
        cell.constituencyLabel.text = entry.party
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(data.politiciansArr[indexPath.row].firstName)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToProfile" {
            let destination = segue.destinationViewController as? PoliticianProfileViewController
            let polIndex = tableView.indexPathForSelectedRow?.row
            destination?.currentPol = data.politiciansArr[polIndex!]
    }
}
}