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
    var enter = false
    var done = false
    var str = ""
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let client = TWTRAPIClient()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        if enter {
            if (currentPol?.twitter != "")  && (currentPol?.twitter != "na") {
                self.dataSource = TWTRUserTimelineDataSource(screenName: currentPol!.twitter, APIClient: client)
                tableView.reloadData()
            } else {
                done = true
                tableView.reloadData()
            }
            enter = false
        }
        tableView.intrinsicContentSize()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: "This politician does not have twitter.", attributes: attrs)
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if done {
            return true
        } else {
            return false
        }
    }
    
}
