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
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dataSource = TWTRUserTimelineDataSource(screenName: self.currentPol!.twitter, APIClient: client)
                self.tableView.reloadData()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.done = true
                    self.tableView.reloadData()
                })
            }
            enter = false
        }
        tableView.intrinsicContentSize()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: "This politician does not have twitter.", attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "twitter-grey" )
    }
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView) -> Bool {
        if done {
            return true
        } else {
            return false
        }
    }
    
}
