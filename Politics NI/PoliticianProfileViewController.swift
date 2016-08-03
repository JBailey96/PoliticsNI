//
//  PoliticianProfileViewController.swift
//  Politics NI
//
//  Created by App Camp on 23/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit


class PoliticianProfileViewController: UIViewController {
    let rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var polPartyName: UIButton!
    @IBOutlet weak var phoneNumTextView: UITextView!
    @IBOutlet weak var polProfileImage: UIImageView!
    @IBOutlet weak var polName: UILabel!
    @IBOutlet weak var altEmailTextView: UITextView!
    @IBOutlet weak var polPartyImage: UIImageView!
    @IBOutlet weak var emailTextView: UITextView!
    
    var currentPol: Politician?
    var party: Party?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        polPartyName.hidden = true
        loadParties()
        
        //setting up properties of nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //hiding twitter options until verified politician has twitter
        
            let mlaRef = rootRef.child("MLAContact") //
        
            mlaRef.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                print(self.currentPol?.id)
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    if (self.currentPol!.id == childSnapshot.value!.objectForKey("id")?.stringValue) {
                        let phoneNum = childSnapshot.value!.objectForKey("Telephone Number")?.stringValue
                        self.currentPol?.phoneNumber = phoneNum!
                        print(self.currentPol?.phoneNumber)
                        self.phoneNumTextView.text = "0" + (self.currentPol?.phoneNumber)!
                        
                        let email = childSnapshot.value!.objectForKey("Email contact address") as! String
                        print(email)
                        self.currentPol?.email = email
                        self.emailTextView.text = email
                        
                        let twitter = childSnapshot.value!.objectForKey("Twitter") as! String
                        self.currentPol?.twitter = twitter
                        
                        let altEmail = childSnapshot.value!.objectForKey("Alternative Email contact") as! String
                        self.currentPol?.altEmail = altEmail
                        self.altEmailTextView.text = altEmail
                        
                    }
                }
                
                if (self.currentPol?.twitter == "na") {
                    if  let arrayOfTabBarItems = self.tabBarController!.tabBar.items as! AnyObject as? NSArray,tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                        tabBarItem.enabled = false
                    }
                }
                
                }, withCancelBlock:  { error in
                    print(error.description)
            })
        
        
        // Add a button to the center of the view to show the timeline
    }
    
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string:(currentPol?.imageURL)!)
        let dat = NSData(contentsOfURL: url!)
        let image = UIImage(data: dat!)
        polProfileImage.image = image
        //polProfileImage.layer.cornerRadius = 25
       // polProfileImage.layer.masksToBounds = true
       // polProfileImage.layer.borderWidth = 0.1;
        polName.text = (currentPol?.firstName)! + " " + (currentPol?.lastName)! + ", MLA"
    }
    
    
    func loadParties() {
        let partiesRef = FIRDatabase.database().reference().child("parties").child("party")
        partiesRef.observeEventType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                let name = childSnapshot.value!.objectForKey("name") as! String
                if (self.currentPol?.party == name) {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    let id = childSnapshot.value!.objectForKey("PartyOrganisationId") as! String
                    let email = childSnapshot.value!.objectForKey("email") as! String
                    let logo = childSnapshot.value!.objectForKey("logo") as! String
                    let phoneNum = childSnapshot.value!.objectForKey("phoneNum") as! String
                    let webLink = childSnapshot.value!.objectForKey("webLink") as! String
                    let twitter = childSnapshot.value!.objectForKey("twitter") as! String
                    self.party = Party(id: id, name: name, logo: logo, webLink: webLink, twitterLink: twitter, phoneNum: phoneNum, email: email)
                    self.polPartyImage.image = UIImage(named: (self.party?.logo)!)
                    self.polPartyName.setTitle(name, forState: UIControlState.Normal)
                    self.polPartyName.hidden = false
                }
            }
            
        })
}
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToParty" {
            let tabBarC : UITabBarController = segue.destinationViewController as! UITabBarController
            let desView: PartyProfileVIewController = tabBarC.viewControllers?.first as! PartyProfileVIewController
            let des2View: PartyTwitterController = tabBarC.viewControllers?[1] as! PartyTwitterController
            let des3View: PartyIssuesViewController = tabBarC.viewControllers?[2] as! PartyIssuesViewController
            desView.currentParty = party
            des2View.currentParty = party
            des3View.currentParty = party
        }
    }
}