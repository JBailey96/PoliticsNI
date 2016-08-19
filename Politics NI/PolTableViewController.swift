//
//  PolTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 21/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD
import SwiftyJSON

class PolTableViewController:  UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var politciansArr = [Politician]() //array of all the politicians
    var myPol = [Politician]() //array of your politicians
    lazy var userConstituency = userUtility.user.constituency //get current user's constituency
    var currentPol: Politician?
    var indexPathPol: Int?
    var done = false
    var display = false
    var data: NSData?
    
    
    @IBOutlet weak var constituencyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //finds your constituency's politicians
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
        
        self.politciansArr = [Politician]()
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), {() -> Void in
            SVProgressHUD.show()
            let webAddress = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllCurrentMembers"
            let url = NSURL(string: webAddress)
            let request = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
            
            let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            urlconfig.timeoutIntervalForRequest = 10
            //urlconfig.timeoutIntervalForResource = 10
            let session = NSURLSession(configuration: urlconfig)
            
            let semaphore = dispatch_semaphore_create(0)
            session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                self.data = data
                print(data)
                print(response)
                print(error)
                dispatch_semaphore_signal(semaphore)
            }).resume()
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            
            if (self.data != nil) {
                let json = JSON(data: self.data!)
                for item in json["AllMembersList"]["Member"].arrayValue {
                    let id = item["PersonId"].stringValue
                    let firstName = item["MemberFirstName"].stringValue
                    let lastName = item["MemberLastName"].stringValue
                    let constituency = item["ConstituencyName"].stringValue
                    let party = item["PartyName"].stringValue
                    let imageURL = item["MemberImgUrl"].stringValue
                    let email = ""
                    let phoneNumber = ""
                    let altEmail = ""
                    let twitter = ""
                    
                    
                    let pol = Politician(id: id, firstName: firstName, lastName: lastName, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber, twitter: twitter, altEmail: altEmail)
                    self.politciansArr.append(pol)
                }
                
                for member in self.politciansArr {
                    if self.userConstituency == member.constituency {
                        self.myPol.append(member)
                    }
                }
                //SVProgressHUD.dismiss()
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            } else {
                //SVProgressHUD.dismiss()
                self.done = true
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        
        })
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
//            
//            let urlString = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllCurrentMembers"
//            
//            if let url = NSURL(string: urlString) {
//                if let data = try? NSData(contentsOfURL: url, options: []) {
//                    let json = JSON(data: data)
//                    for item in json["AllMembersList"]["Member"].arrayValue {
//                        let id = item["PersonId"].stringValue
//                        let firstName = item["MemberFirstName"].stringValue
//                        let lastName = item["MemberLastName"].stringValue
//                        let constituency = item["ConstituencyName"].stringValue
//                        let party = item["PartyName"].stringValue
//                        let imageURL = item["MemberImgUrl"].stringValue
//                        let email = ""
//                        let phoneNumber = ""
//                        let altEmail = ""
//                        let twitter = ""
//                        
//                        let pol = Politician(id: id, firstName: firstName, lastName: lastName, constituency: constituency, party: party, imageURL: imageURL, email: email, phoneNumber: phoneNumber, twitter: twitter, altEmail: altEmail)
//                        self.politciansArr .append(pol)
//                    }
//                }
//            }
//            
//            for member in self.politciansArr {
//                if self.userConstituency == member.constituency {
//                    self.myPol.append(member)
//                }
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), {() -> Void in
//                self.firstAttempt = false
//                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
//            })
//            
//        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (display) {
            return myPol.count + 1
        } else {
            return myPol.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (display) && (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath)
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
        
        if (indexPath.row == myPol.count+1) {
            display = true
        }
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
            display = false
        } else {
            display = true
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (display) && indexPath.row == 0 {
            return 150
        }
        return 90
    }
    
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if done {
            return true
        } else {
            return false
        }
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "group")!
    }
    
    
//    func getData() {
//        let webAddress = "http://data.niassembly.gov.uk/members_json.ashx?m=GetAllCurrentMembers"
//        let url = NSURL(string: webAddress)
//        let request = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
//        
//        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        urlconfig.timeoutIntervalForRequest = 12
//        urlconfig.timeoutIntervalForResource = 12
//        let session = NSURLSession(configuration: urlconfig)
//        
//        session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
//            print(data)
//            print(response)
//            print(error)
//        }).resume()
//        
//    }
    
    

    
}