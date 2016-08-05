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

class EditDetailsViewController: UIViewController, CLLocationManagerDelegate {
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
        
        postCode.hidden = true
        changeEmail.text = FIRAuth.auth()?.currentUser?.email
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    
    
    
    @IBAction func findLocat(sender: AnyObject) {
        if (postCode.hidden == true) {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .NotDetermined, .Restricted, .Denied:
                    alert("Problem with your location services.")
                    postCode.hidden = false
                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    let latitude = String(format: "%f", locationManager.location!.coordinate.latitude)
                    let longitude = String(format: "%f", locationManager.location!.coordinate.longitude)
                    userConstit = DatabaseUtility.getConstituency(latitude, long: longitude)
                    userUtility.user.constituency = userConstit
                    
                    if userConstit == "" {
                        alert("Problem with your location services.")
                        postCode.hidden = false
                    } else {
                        locat.text = userConstit
                        self.locationSet = true
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
    
    @IBAction func clearTextFields(sender: AnyObject) {
        let field = sender as! UITextField
        field.text = ""
    }
    
    @IBAction func editDetails(sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail((user?.email)!, password: currentPass.text!)
        
        let newEmail = changeEmail.text
        
        user!.reauthenticateWithCredential(credential) { error in
            if let error = error {
                print("Please enter your current password.")
            } else {
                // User re-authenticated.
            }
        }
        
        user!.updateEmail(newEmail!) { error in
            if let error = error {
                self.alert("Error with email entry.")
            } else {
                self.updatePass()
            }
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
                            self.alert("Settings updated.")
                            self.performSegueWithIdentifier("returntoHub", sender: self)
                        }
                    }
                }
            }
        } else {
            alert("Settings updated.")
            performSegueWithIdentifier("returntoHub", sender: self)
        }
        
    }
}