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
    
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var polNameTwitter: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var polProfileImage: UIImageView!
    @IBOutlet weak var polName: UILabel!
    @IBOutlet weak var polParty: UILabel!
    @IBOutlet weak var polPartyImage: UIImageView!
    var currentPol: Politician?
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
            //let mlaRef = rootRef.child(pol.id)
            //print(mlaRef)
            
            rootRef.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                print(self.currentPol?.id)
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    if (self.currentPol!.id == childSnapshot.value!.objectForKey("id")?.stringValue) {
                        let phoneNum = childSnapshot.value!.objectForKey("Telephone Number")?.stringValue
                        self.currentPol?.phoneNumber = phoneNum!
                        print(self.currentPol?.phoneNumber)
                        self.phoneNumber.text = "0" + (self.currentPol?.phoneNumber)!
                        
                        let email = childSnapshot.value!.objectForKey("Email contact address") as! String
                        print(email)
                        self.currentPol?.email = email
                        self.emailAddress.text = email
                        
                        let twitter = childSnapshot.value!.objectForKey("Twitter") as! String
                        print(twitter)
                        self.currentPol?.twitter = twitter
                        
                        let altEmail = childSnapshot.value!.objectForKey("Alternative Email contact") as! String
                        self.currentPol?.altEmail = altEmail
                        
                    }
                }
                
                let client = TWTRAPIClient()
                client.loadUserWithID("12") { (user, error) -> Void in
                    
                }
                
                
//                for child in snapshot.children {
//                    if let w = child.value.objectForKey("Twitter") as? String {
//                        print(w)
//                    }
//                }
//                twitter  = (snapshot.value!.objectForKey("Twitter")!) as! String
//                phoneNum = (snapshot.value!.objectForKey("Telephone Number"))!.stringValue
//                altEmail = (snapshot.value!.objectForKey("Alternative Email contact"))! as! String
//                email = (snapshot.value!.objectForKey("Email contact address"))! as! String
//                self.currentPol?.twitter = twitter
//                self.currentPol?.phoneNumber = phoneNum
//                self.currentPol?.altEmail = altEmail
//                self.currentPol?.email = email
//                self.phoneNumber.text = "0" + (phoneNum)
                }, withCancelBlock:  { error in
                    print(error.description)
            })
        
        // Add a button to the center of the view to show the timeline
        button.addTarget(self, action: #selector(showTimeline), forControlEvents: [.TouchUpInside])
        view.addSubview(button)
    }
    
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string:(currentPol?.imageURL)!)
        let dat = NSData(contentsOfURL: url!)
        let image = UIImage(data: dat!)
        polProfileImage.image = image
        //polProfileImage.layer.cornerRadius = 25
       // polProfileImage.layer.masksToBounds = true
       // polProfileImage.layer.borderWidth = 0.1;
        polName.text = (currentPol?.firstName)! + " " + (currentPol?.lastName)!
        polParty.text = (currentPol?.party)
        polNameTwitter.text = polName.text
    }
    
    func showTimeline() {
        // Create an API client and data source to fetch Tweets for the timeline
        let client = TWTRAPIClient()
        //TODO: Replace with your collection id or a different data source
        let dataSource = TWTRUserTimelineDataSource(screenName: currentPol!.twitter, APIClient: client)
        // Create the timeline view controller
        let timelineViewControlller = TWTRTimelineViewController(dataSource: dataSource)
        // Create done button to dismiss the view controller
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dismissTimeline))
        timelineViewControlller.navigationItem.leftBarButtonItem = button
        // Create a navigation controller to hold the
        let navigationController = UINavigationController(rootViewController: timelineViewControlller)
        showDetailViewController(navigationController, sender: self)
    }
    func dismissTimeline() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}