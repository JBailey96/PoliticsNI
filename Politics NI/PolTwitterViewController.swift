//
//  PolTwitterViewController.swift
//  Politics NI
//
//  Created by App Camp on 29/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import TwitterKit

class PolTwitterViewController: TWTRTimelineViewController {
    var currentPol: Politician?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let client = TWTRAPIClient()
            self.dataSource = TWTRUserTimelineDataSource(screenName: currentPol!.twitter, APIClient: client)
    }
}
