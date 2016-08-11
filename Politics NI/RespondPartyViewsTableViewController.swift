//
//  RespondPartyViewsTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 09/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class RespondPartyViewsTableViewController: UITableViewController {
    
    var partyViews = [PartyView]()
    var agreeViews =  [PartyView]()
    var disagreeViews =  [PartyView]()
    var unsureViews = [PartyView]()
    var neutralViews = [PartyView]()
    var opinions =  [String]()
    var parties = [Party]()
    
    override func viewDidLoad() {
        agreeViews = userUtility.agreeViews
        disagreeViews = userUtility.disagreeViews
        unsureViews = userUtility.unsureViews
        neutralViews = userUtility.neutralViews
        
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyViews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell5", forIndexPath: indexPath) as! RespondPartyViewsCellViewController
        let entry = partyViews[indexPath.row]
        cell.partyView.text = entry.view
        cell.partySrc.text = entry.viewsrc
        cell.partyLogo.image = setLogo(entry.partyID)
        let opinion = chooseOpinion()
        opinions.append(opinion)
        
        cell.userOpinion.text = opinions[indexPath.row]
        return cell
    }
    
    
    func chooseOpinion() -> String! {
        
        for view in partyViews {
        for viewOp in agreeViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    self.agreeViews.removeAtIndex(viewOp.index)
                    return "You agree with this view"
                }
            }
        }
        
        for view in partyViews {
        for viewOp in disagreeViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    self.disagreeViews.removeAtIndex(viewOp.index)
                    return "You disagree with this view"
                }
            }
        }
        
        for view in partyViews {
        for viewOp in unsureViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    self.unsureViews.removeAtIndex(viewOp.index)
                    return "You are undecided with this view"
                }
            }
        }
        
        for view in partyViews {
        for viewOp in neutralViews.enumerate() {
            if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    self.neutralViews.removeAtIndex(viewOp.index)
                    return "You neither agree nor disagree with this view"
                }
            }
        }
        return ""
    }
    
    func setLogo(partyID: String) -> UIImage {
        switch partyID {
        case "20":
            return UIImage(named: "dup.png")!
        case "24":
            return UIImage(named: "sf.png")!
        case "19":
            return UIImage(named: "alliance.png")!
        case "23":
            return UIImage(named: "sdlp.png")!
        case "26":
            return UIImage(named: "uup.png")!
        case "141":
            return UIImage(named: "tuv.png")!
        case "111":
            return UIImage(named: "green.png")!
        case "1533":
            return UIImage(named: "pbp.png")!
        default: break
        }
        return UIImage(named: "")!
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
}
