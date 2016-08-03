//
//  RegisterViewController.swift
//  Politics NI
//
//  Created by App Camp on 25/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class RegisterViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    let pickerData = ["Prefer not to say", "Under 16", "17-19", "20-24", "25-49", "50+"]
    
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var homePostCode: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var preferNotToSay: UIButton!
    @IBOutlet weak var fullName: UITextField!
    
    var gender: String!
    var genderSet: Bool = false
    var fullName1: String!
    var userConstit: String!
    var locationSet: Bool = false
    var userAge: String = "Prefer not to say"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        homePostCode.hidden = true
        self.agePicker.delegate = self
        self.agePicker.dataSource = self
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userAge = pickerData[row]
        print(userAge)
    }
    
    func passAuth() -> Bool {
        let pass1 = password1.text
        let pass2 = password2.text
        
        if (pass1 != pass2) {
            alert("Passwords do not match")
            return false
        }
        return true
    }
    
    func dateAuth() -> Bool {
        if(userAge == "") {
            return false
        }
        return true
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        if passAuth() && dateAuth() && validateFullName() && genderAuth() && LocationAuth() {
            FIRAuth.auth()?.createUserWithEmail(email1.text!, password: password1.text!) { (user, error) in
                print(error?.description)
                if let error = error {
                    self.alert("Could not sign up.")
                }
                if let user = user {
                    let user1 = ["full_name": self.fullName1, "dob": self.userAge, "gender": self.gender, "constituency": self.userConstit]
                    self.ref.child("users").child(user.uid).setValue(user1)
                    userUtility.getUserInfo()
                    self.performSegueWithIdentifier("finishReg", sender: self)
                }
            }
        }
    }
    
    func genderAuth() -> Bool {
        if genderSet == false {
            alert("You have not selected a gender")
            return false
        }
        return true
    }
    
    func LocationAuth() -> Bool {
        if locationSet == false {
            alert("You have not found your location.")
            return false
        }
        return true
    }
    
    @IBAction func clickMale(sender: AnyObject) {
        gender = "M"
        maleButton.setTitleColor(UIColor(red:0.15, green:0.40, blue:0.95, alpha:1.0), forState: UIControlState.Normal)
        femaleButton.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        preferNotToSay.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        self.genderSet = true
    }
    
    @IBAction func clickFemale(sender: AnyObject) {
        gender = "F"
        femaleButton.setTitleColor(UIColor(red:0.15, green:0.40, blue:0.95, alpha:1.0), forState: UIControlState.Normal)
        maleButton.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        preferNotToSay.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        self.genderSet = true
    }
    
    @IBAction func clickNA(sender: AnyObject) {
        gender = "N"
        preferNotToSay.setTitleColor(UIColor(red:0.15, green:0.40, blue:0.95, alpha:1.0), forState: UIControlState.Normal)
        maleButton.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        femaleButton.setTitleColor(UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0), forState: UIControlState.Normal)
        self.genderSet = true
    }
    
    
    @IBAction func findLocat(sender: AnyObject) {
        if (homePostCode.hidden == true) {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .NotDetermined, .Restricted, .Denied:
                    alert("Problem with your location services.")
                    homePostCode.hidden = false
                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    let latitude = String(format: "%f", locationManager.location!.coordinate.latitude)
                    let longitude = String(format: "%f", locationManager.location!.coordinate.longitude)
                    userConstit = DatabaseUtility.getConstituency(latitude, long: longitude)
                    print(userConstit)
                    
                    if userConstit == "" {
                        alert("Problem with your location services.")
                        homePostCode.hidden = false
                    } else {
                        location.text = userConstit
                        self.locationSet = true
                    }
                }
            } else {
                alert("Problem with your location services.")
                homePostCode.hidden = false
            }
        } else {
            let postcode = homePostCode.text
            findLocatPostCode(postcode!)
        }
        }
    
    func findLocatPostCode(postCode: String) {
        userConstit = DatabaseUtility.getConstituencyPostCode(postCode)
        
        if userConstit == "" {
            alert("Problem with your location services.")
        } else {
            location.text = userConstit
            self.locationSet = true
        }
    }
    
    func validateFullName() -> Bool {
        if (fullName.text?.characters.count > 70) {
            alert("Full name is too long.")
            return false
        }
        else if (fullName.text == "") {
                alert("You have not entered your full name.")
                return false
        }
          self.fullName1 = self.fullName.text
          return true
    }
    
    @IBAction func clearTextFields(sender: AnyObject) {
        let field = sender as! UITextField
        field.text = ""
    }
    
    func alert(alertDesc: String) {
        let alert = UIAlertController(title: "Alert", message: alertDesc, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    }
