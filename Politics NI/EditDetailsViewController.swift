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
import SCLAlertView

class EditDetailsViewController: UITableViewController, UITextFieldDelegate {
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    var userConstit: String!
    var locationSet: Bool = false
    
    @IBOutlet weak var changeEmail: UITextField!
    @IBOutlet weak var currentPass: UITextField!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var locat: UILabel!
    @IBOutlet weak var postCode: UITextField!

    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.hidden = true
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        changeEmail.delegate = self
        currentPass.delegate = self
        newPass.delegate = self
        postCode.delegate = self
        
        postCode.hidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        userConstit = userUtility.user.constituency
    }
    
    
    
    
    @IBAction func findLocat(sender: AnyObject) {
//        if (postCode.hidden == true) {
//            if CLLocationManager.locationServicesEnabled() {
//                switch(CLLocationManager.authorizationStatus()) {
//                case .NotDetermined, .Restricted, .Denied:
//                    SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
//                    postCode.hidden = false
//                case .AuthorizedAlways, .AuthorizedWhenInUse:
//                    if locationManager.location != nil {
//                        let latitude = String(format: "%f", locationManager.location!.coordinate.latitude)
//                        let longitude = String(format: "%f", locationManager.location!.coordinate.longitude)
//                        userConstit = DatabaseUtility.getConstituency(latitude, long: longitude)
//                        if userConstit == "" {
//                            SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
//                            postCode.hidden = false
//                        } else {
//                            locat.text = userConstit
//                            self.locationSet = true
//                        }
//                    } else {
//                        SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
//
//                        postCode.hidden = false
//                    }
//                }
//            } else {
//                SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
//
//                postCode.hidden = false
//            }
//        } else {
            let postcode = postCode.text
            findLocatPostCode(postcode!)
//        }
    }
    
    func findLocatPostCode(postCode: String) {
        userConstit = DatabaseUtility.getConstituencyPostCode(postCode)
        
        if userConstit == "" {
            SCLAlertView().showError("Error", subTitle: "Not a valid Northern Ireland postcode.")
        } else {
            locationLabel.hidden = false
            locat.text = userConstit
            self.locationSet = true
            userUtility.user.constituency = userConstit
        }
    }
    
    
    
    @IBAction func editDetails(sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail((user?.email)!, password: currentPass.text!)
        
        let newEmail = changeEmail.text
        
        user!.reauthenticateWithCredential(credential) { error in
            if let error = error {
                SCLAlertView().showError("Error", subTitle: "Have you entered your current password correctly?")
            } else {
                if newEmail != "" {
                    user!.updateEmail(newEmail!) { error in
                        if let error = error {
                            SCLAlertView().showError("Error", subTitle:"Have you entered a valid new email address?")
                        } else {
                            self.updatePass()
                        }
                    }
                } else {
                    self.updatePass()
                }
            }
        }
        }
    
    func updatePass() {
        let user = FIRAuth.auth()?.currentUser
        if newPass.text != "" {
            let credential = FIREmailPasswordAuthProvider.credentialWithEmail((user?.email)!, password: currentPass.text!)
            user!.reauthenticateWithCredential(credential) { error in
                if let error = error {
                    SCLAlertView().showError("Error", subTitle: "Have you entered your current password correctly?")
                } else {
                    let newPassword = self.newPass.text
                    user!.updatePassword(newPassword!) { error in
                        if let error = error {
                            SCLAlertView().showError("Error", subTitle: "Have you entered your new password correctly?")
                        } else {
                            let user1 = ["dob": userUtility.user.birthDay, "gender": userUtility.user.gender, "constituency": self.userConstit]
                            self.ref.child("users").child(user!.uid).setValue(user1)
                            userUtility.getUserInfo()
                            
                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("Ok", target:self, selector:#selector(EditDetailsViewController.firstButton))
                            alert.showSuccess("Well done!", subTitle: "You have successfully updated your settings.")
                        }
                    }
                }
            }
        } else {
            self.ref.child("users").child(user!.uid).child("constituency").setValue(self.userConstit)
            userUtility.getUserInfo()
            //performSegueWithIdentifier("settingsUpdated", sender: self)
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("Ok", target:self, selector:#selector(EditDetailsViewController.firstButton))
            alert.showSuccess("Well done!", subTitle: "You have successfully updated your settings.")
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
    
    func firstButton() {
        performSegueWithIdentifier("settingsUpdated", sender: self)
    }
}