//
//  EditDetailsViewController.swift
//  Politics NI
//
//  Created by App Camp on 31/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class EditDetailsViewController: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    var userConstit: String!
    var locationSet: Bool = false
    
    @IBOutlet weak var changeEmail: UITextField!
    @IBOutlet weak var currentPass: UITextField!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var locat: UILabel!
    @IBOutlet weak var postCode: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        changeEmail.delegate = self
        currentPass.delegate = self
        newPass.delegate = self
        postCode.delegate = self
        
        postCode.hidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        userConstit = userUtility.user.constituency
    }
    
    
    
    
    @IBAction func findLocat(sender: AnyObject) {
        if (postCode.hidden == true) {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .NotDetermined, .Restricted, .Denied:
                    alert("Problem with your location services.")
                    postCode.hidden = false
                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    if locationManager.location != nil {
                        let latitude = String(format: "%f", locationManager.location!.coordinate.latitude)
                        let longitude = String(format: "%f", locationManager.location!.coordinate.longitude)
                        userConstit = DatabaseUtility.getConstituency(latitude, long: longitude)
                        if userConstit == "" {
                            alert("Problem with your location services.")
                            postCode.hidden = false
                        } else {
                            locat.text = userConstit
                            self.locationSet = true
                        }
                    } else {
                        alert("Problem with your location services.")
                        postCode.hidden = false
                    }
                }
            } else {
                alert("Problem with your location services.")
                postCode.hidden = false
            }
        } else {
            let postcode = postCode.text
            findLocatPostCode(postcode!)
        }
    }
    
    func findLocatPostCode(postCode: String) {
        userConstit = DatabaseUtility.getConstituencyPostCode(postCode)
        
        if userConstit == "" {
            alert("Problem with your location services.")
        } else {
            locat.text = userConstit
            self.locationSet = true
            userUtility.user.constituency = userConstit
        }
    }
    
func alert(alertDesc: String) {
    let alert = UIAlertController(title: "Alert", message: alertDesc, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
}
    
    
    @IBAction func editDetails(sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail((user?.email)!, password: currentPass.text!)
        
        let newEmail = changeEmail.text
        
        user!.reauthenticateWithCredential(credential) { error in
            if let error = error {
               self.alert("Error with validation. Have you entered your current password?")
            } else {
            }
        }
        
        if newEmail != "" {
            user!.updateEmail(newEmail!) { error in
                if let error = error {
                    self.alert("Error with email entry.")
                } else {
                    self.updatePass()
                }
            }
        } else {
            self.updatePass()
        }

        }
    
    func updatePass() {
        let user = FIRAuth.auth()?.currentUser
        if newPass.text != "" {
            let credential = FIREmailPasswordAuthProvider.credentialWithEmail((user?.email)!, password: currentPass.text!)
            user!.reauthenticateWithCredential(credential) { error in
                if let error = error {
                    self.alert("Current password not valid.")
                } else {
                    let newPassword = self.newPass.text
                    user!.updatePassword(newPassword!) { error in
                        if let error = error {
                            self.alert("New password not valid.")
                        } else {
                            let user1 = ["dob": userUtility.user.birthDay, "gender": userUtility.user.gender, "constituency": self.userConstit]
                            self.ref.child("users").child(user!.uid).setValue(user1)
                            userUtility.getUserInfo()
                            let alert = UIAlertController(title: "Alert", message: "You have successfully updated your details.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
                                self.performSegueWithIdentifier("settingsUpdated", sender: nil)
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            alert("Settings updated.")
            self.ref.child("users").child(user!.uid).child("constituency").setValue(self.userConstit)
            userUtility.getUserInfo()
            performSegueWithIdentifier("returntoHub", sender: self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    
    @IBAction func dismissKeyboard(sender: AnyObject) {
            changeEmail.resignFirstResponder()
            currentPass.resignFirstResponder()
            newPass.resignFirstResponder()
            postCode.resignFirstResponder()
    }
}