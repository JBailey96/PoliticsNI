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
    

    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandingPageViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandingPageViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
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
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}