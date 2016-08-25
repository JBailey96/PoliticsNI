//
//  PartyTwitterViewController.swift
//  Politics NI
//
//  Created by App Camp on 29/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Foundation
import TwitterKit

class PartyTwitterController: TWTRTimelineViewController {
    var currentParty: Party?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: currentParty!.twitterLink , APIClient: client)
        tableView.intrinsicContentSize()
    }
    
    
}