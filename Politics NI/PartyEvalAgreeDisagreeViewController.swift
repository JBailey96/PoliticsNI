//
//  PartyEvalAgreeDisagreeViewController.swift
//  Politics NI
//
//  Created by App Camp on 16/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//


class PartyEvalAgreeDisagreeViewController: UITableViewController {
    var userRespondIssue = [Issue]()
    var agreeViews = [PartyView]()
    var disagreeViews = [PartyView]()
    var unsureViews = [PartyView]()
    var neutralViews = [PartyView]()
    var party: Party!
    
    @IBAction func segmentChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    var agreeViewsParty = [PartyView]()
    var disagreeViewsParty = [PartyView]()
    var unsureViewsParty = [PartyView]()
    var neutralViewsParty = [PartyView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        
        userRespondIssue = userUtility.issues
        agreeViews = userUtility.agreeViews
        disagreeViews = userUtility.disagreeViews
        neutralViews = userUtility.neutralViews
        unsureViews = userUtility.unsureViews
        sortViews()
    }
    
    func sortViews() {
        for issue in userRespondIssue {
            for view in agreeViews {
                if (view.issueID == issue.id) {
                        if (party.id == view.partyID) {
                           agreeViewsParty.append(view)
                    }
                }
            }
        }
        
            for issue in userRespondIssue {
                for view in disagreeViews {
                    if (view.issueID == issue.id) {
                        if (party.id == view.partyID) {
                            disagreeViewsParty.append(view)
                        }
                    }
                }
        }
        
            
                for issue in userRespondIssue {
                    for view in neutralViews {
                        if (view.issueID == issue.id) {
                            if (party.id == view.partyID) {
                                neutralViewsParty.append(view)
                            }
                        }
                    }
        }
        
                    for issue in userRespondIssue {
                        for view in unsureViews {
                            if (view.issueID == issue.id) {
                                if (party.id == view.partyID) {
                                    unsureViewsParty.append(view)
                                }
                            }
                        }
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell20", forIndexPath: indexPath) as! PartyEvalAgDisCell
        
        var entry: PartyView!
        switch(segment.selectedSegmentIndex) {
        case 0:
            entry = agreeViewsParty[indexPath.row]
        case 1:
            entry = disagreeViewsParty[indexPath.row]
        case 2:
            entry = neutralViewsParty[indexPath.row]
        case 3:
            entry = unsureViewsParty[indexPath.row]
        default:
            break
        }
        
        cell.partyPic.image = UIImage(named: party.logo)
        cell.issueSrc.text = entry.viewsrc
        cell.view.text = "\"" + entry.view + "\""
        cell.issue.text = entry.issueDesc
        return cell
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segment.selectedSegmentIndex) {
        case 0:
            return agreeViewsParty.count
        case 1:
            return disagreeViewsParty.count
        case 2:
            return neutralViewsParty.count
        case 3:
            return unsureViewsParty.count
        default:
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}