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
    
    var agreeViewsSorted =  [PartyView]()
    var disagreeViewsSorted =  [PartyView]()
    var unsureViewsSorted = [PartyView]()
    var neutralViewsSorted = [PartyView]()
    
    var opinions =  [String]()
    var parties = [Party]()
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        agreeViews = userUtility.agreeViews
        disagreeViews = userUtility.disagreeViews
        unsureViews = userUtility.unsureViews
        neutralViews = userUtility.neutralViews
        chooseOpinion()
        
        super.viewDidLoad()
        //opinions.removeAll()
        //chooseOpinion()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let returnValue = 0
        switch(mySegmentedControl.selectedSegmentIndex) {
        case 0:
            return agreeViewsSorted.count
        case 1:
            return disagreeViewsSorted.count
        case 2:
            return neutralViewsSorted.count
        case 3:
            return unsureViewsSorted.count
        default:
            break
        }
        return returnValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell5", forIndexPath: indexPath) as! RespondPartyViewsCellViewController
        
        var entry: PartyView!
        switch(mySegmentedControl.selectedSegmentIndex) {
            case 0:
            entry = agreeViewsSorted[indexPath.row]
            case 1:
            entry = disagreeViewsSorted[indexPath.row]
            case 2:
            entry = neutralViewsSorted[indexPath.row]
            case 3:
            entry = unsureViewsSorted[indexPath.row]
            default:
            break
        }

        cell.partyView.text = entry.view
        cell.partySrc.text = entry.viewsrc
        cell.partyLogo.image = setLogo(entry.partyID)
        //cell.userOpinion.text = opinions[indexPath.row]
        return cell
    }
    
    
    func chooseOpinion() {
        for view in partyViews {
            for viewOp in agreeViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    agreeViewsSorted.append(view)
                    self.agreeViews.removeAtIndex(viewOp.index)
                }
            }
        
        for viewOp in disagreeViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    disagreeViewsSorted.append(view)
                    self.disagreeViews.removeAtIndex(viewOp.index)
                }
            }
        
        for viewOp in unsureViews.enumerate() {
                if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    unsureViewsSorted.append(view)
                    self.unsureViews.removeAtIndex(viewOp.index)
            }
            }
        
        for viewOp in neutralViews.enumerate() {
            if (view.partyID == viewOp.element.partyID) && (view.issueID == viewOp.element.issueID) {
                    neutralViewsSorted.append(view)
                    self.neutralViews.removeAtIndex(viewOp.index)
            }
            }
    }
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
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
}
