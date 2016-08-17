//
//  PolTwitterViewController.swift
//  Politics NI
//
//  Created by App Camp on 29/07/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import TwitterKit

class PolTwitterViewController: TWTRTimelineViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var currentPol: Politician?
    var firstAttempt = true
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let client = TWTRAPIClient()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        if (currentPol?.twitter != "")  && (currentPol?.twitter != "na") {
            self.dataSource = TWTRUserTimelineDataSource(screenName: currentPol!.twitter, APIClient: client)
        }
        tableView.intrinsicContentSize()
        firstAttempt = false
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "This politician does not have a twitter account."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if (firstAttempt) {
            return false
        } else {
            return true
        }
    }
    
}
