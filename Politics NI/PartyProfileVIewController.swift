//
//  PartyProfileVIewController.swift
//  Politics NI
//
//  Created by App Camp on 28/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import TwitterKit

class PartyProfileVIewController: UIViewController {
    var currentParty: Party?
    
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var phoneNum: UITextView!
    @IBOutlet weak var webLink: UITextView!
    @IBOutlet weak var partyLogo: UIImageView!
    @IBOutlet weak var emailAddress: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Party"
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        self.navigationController?.navigationBar.backItem?.title
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
}
    override func viewWillAppear(animated: Bool) {
        partyLogo.image = UIImage(named: (currentParty?.logo)!)
        phoneNum.text = currentParty?.phoneNum
        partyName.text = currentParty?.name
        webLink.text = currentParty?.webLink
        emailAddress.text = currentParty?.email
        //polNameTwitter.text = polName.text
    }
    
    
    

}
