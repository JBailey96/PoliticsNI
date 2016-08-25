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
import SCLAlertView
    
class LandingPageViewController: UIViewController, UITextFieldDelegate {
    let data = PolTableViewController()
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    

    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.delegate = self
        password.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandingPageViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LandingPageViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        self.navigationController?.view.backgroundColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
    }
    @IBAction func logInButton(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailAddress.text!, password: password.text!) { (user, error) in
            if let error = error {
                
                let appearance = SCLAlertView.SCLAppearance(showCloseButton:true)
                let alert = SCLAlertView(appearance: appearance)
                alert.showError("Error logging in", subTitle: "Could not recognise your details.")
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.password) {
            logInButton(textField)
        }
        emailAddress.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin.y = -keyboardSize.height
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if self.view.frame.origin.y != 0 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
    }
    
    

}