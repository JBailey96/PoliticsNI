//
//  ViewController.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var politiciansArr = DatabaseUtility.loadAllMembers()
    var myPoliticians = [Politician]()
    var parties = DatabaseUtility.getParties()
    var constituencies = DatabaseUtility.getConstituencies()
    
    @IBOutlet var consPick: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var polName: UILabel!
    @IBOutlet weak var polParty: UILabel!
    
    
    override func viewDidLoad() {
        politiciansArr = DatabaseUtility.loadAllMembers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var userchoice: UITextField!
    @IBAction func submit(sender: AnyObject) {
        let usrConstituency = userchoice.text
        myPoliticians.removeAll()
        
        for member in politiciansArr {
            if member.constituency == usrConstituency! {
                myPoliticians.append(member)
            }
        }
        loadMember(myPoliticians[0])
    }
    func loadMember(polit: Politician) {
        let url = NSURL(string:polit.imageURL)
        let data = NSData(contentsOfURL: url!)
        profilePic.image = UIImage(data: data!)
        polName.text = polit.firstName + " " + polit.lastName
        polParty.text = polit.party
    }
    
    @IBAction func choices(sender: AnyObject) {
        
        switch (sender.tag) {
        case 1:
            loadMember(myPoliticians[0])
        case 2:
            loadMember(myPoliticians[1])
        case 3:
            loadMember(myPoliticians[2])
        case 4:
            loadMember(myPoliticians[3])
        case 5:
            loadMember(myPoliticians[4])
        case 6:
            loadMember(myPoliticians[5])
        default:
            loadMember(myPoliticians[0])
        }
    }
    
}

