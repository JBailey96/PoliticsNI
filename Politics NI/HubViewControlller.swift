//
//  HubViewControlller.swift
//  Politics NI
//
//  Created by App Camp on 27/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import UIKit

class HubViewControlller: UITableViewController {
    @IBOutlet weak var openSide: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
         self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() 
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 24)!
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        //self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        
        if self.revealViewController() != nil {
            openSide.target = self.revealViewController()
            openSide.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 500
        }
    }

}
