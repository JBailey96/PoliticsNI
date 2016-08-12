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
import SCLAlertView

class RegisterViewController: UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    let pickerData = ["Prefer not to say", "Under 16", "17-19", "20-24", "25-49", "50+"]
    
    @IBOutlet weak var homePostCode: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var preferNotToSay: UIButton!
    
    @IBOutlet weak var ageField: UITextField!
    var gender: String!
    var genderSet: Bool = false
    var userConstit: String!
    var locationSet: Bool = false
    var userAge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        homePostCode.hidden = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        let pickerView  : UIPickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        ageField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(RegisterViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(RegisterViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        ageField.inputAccessoryView = toolBar
        
        homePostCode.delegate = self
        password1.delegate = self
        password2.delegate = self
        email1.delegate = self
        ageField.delegate = self
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
        ageField.text = userAge
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
            alert("You have not set your age.")
            return false
        }
        return true
    }
    
    @IBAction func registerButton(sender: AnyObject) {
        if dateAuth() && genderAuth() && LocationAuth() && passAuth() {
            FIRAuth.auth()?.createUserWithEmail(email1.text!, password: password1.text!) { (user, error) in
                print(error?.description)
                if let error = error {
                    self.alert("Could not sign up. Have you entered a valid password and email?")
                }
                if let user = user {
                    let user1 = ["dob": self.userAge, "gender": self.gender, "constituency": self.userConstit]
                    self.ref.child("users").child(user.uid).setValue(user1)
                    userUtility.getUserInfo()
                    userUtility.getUserIssues()
                    userUtility.issues = [Issue]()
                    userUtility.agreeViews = [PartyView]()
                    userUtility.disagreeViews = [PartyView]()
                    userUtility.unsureViews = [PartyView]()
                    userUtility.neutralViews = [PartyView]()
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
                    SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
                    homePostCode.hidden = false
                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    if locationManager.location != nil {
                    let latitude = String(format: "%f", locationManager.location!.coordinate.latitude)
                    let longitude = String(format: "%f", locationManager.location!.coordinate.longitude)
                    userConstit = DatabaseUtility.getConstituency(latitude, long: longitude)
                        if userConstit == "" {
                            SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
                            homePostCode.hidden = false
                        } else {
                            location.text = userConstit
                            self.locationSet = true
                        }

                    } else {
                        SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
                        homePostCode.hidden = false
                                }
                }
            } else {
               SCLAlertView().showWarning("Warning", subTitle: "Problem with your location services. Please enter your home postcode.")
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
            SCLAlertView().showWarning("Warning", subTitle: "Problem with your postcode entry. Is it a valid Northern Ireland postcode?")        }
        else {
            location.text = userConstit
            self.locationSet = true
        }
    }
    
    
    func alert(alertDesc: String) {
       SCLAlertView().showError("Error with registration", subTitle: alertDesc)
    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        homePostCode.resignFirstResponder()
//        password1.resignFirstResponder()
//        password2.resignFirstResponder()
//        email1.resignFirstResponder()
//        ageField.resignFirstResponder()
//        return true
//    }
//    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        view.endEditing(true)
//        super.touchesBegan(touches, withEvent: event)
//        homePostCode.resignFirstResponder()
//        password1.resignFirstResponder()
//        password2.resignFirstResponder()
//        email1.resignFirstResponder()
//        ageField.resignFirstResponder()
//    }
//   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        //password1.resignFirstResponder()
        view.endEditing(true)
    }
    
    func doneClick() {
        ageField.resignFirstResponder()
    }
    
    
    func cancelClick() {
        ageField.resignFirstResponder()
    }
    
    

    
    
}

