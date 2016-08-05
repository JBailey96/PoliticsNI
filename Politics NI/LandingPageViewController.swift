	//
//  LandingPageViewController.swift
//  Politics NI
//
//  Created by App Camp on 26/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LandingPageViewController: UIViewController {
    let data = PolTableViewController()
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logInButton(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailAddress.text!, password: password.text!) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Could not log in.", message: "Your details are not recognised.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                userUtility.issues = [Issue]()
                userUtility.agreeViews = [PartyView]()
                userUtility.disagreeViews = [PartyView]()
                userUtility.unsureViews = [PartyView]()
                userUtility.neutralViews = [PartyView]()
                userUtility.getUserInfo()
                userUtility.getUserIssues()
                self.performSegueWithIdentifier("takeToHub", sender: self)
            }
        }
}
    
    @IBAction func clearTextFields(sender: AnyObject) {
        let textfield = sender as! UITextField
        textfield.text = ""
    }
}