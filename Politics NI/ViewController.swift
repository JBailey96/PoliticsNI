//
//  ViewController.swift
//  Politics NI
//
//  Created by App Camp on 20/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var politiciansArr = [Politician]()
    @IBOutlet weak var consChoices: UIPickerView!
    var myPoliticians = [Politician]()
    
    var constituencies = ["East Antrim","East Belfast","East Londonderry","Fermanagh and South Tyrone", "Foyle", "Lagan Valley", "Mid Ulster", "Newry and Armagh", "North Antrim", "North Belfast", "North Down", "South Antrim", "South Belfast", "South Down", "Strangford", "Upper Bann", "West Belfast", "West Tyrone"]
    
    @IBOutlet var consPick: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var polName: UILabel!
    @IBOutlet weak var polParty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    @IBAction func choice(sender: AnyObject) {
        switch(sender.tag) {
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
    func loadMember(polit: Politician) {
        let url = NSURL(string:polit.imageURL)
        let data = NSData(contentsOfURL: url!)
        profilePic.image = UIImage(data: data!)
        polName.text = polit.name
        polParty.text = polit.party
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return constituencies.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return constituencies[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    }
    }

