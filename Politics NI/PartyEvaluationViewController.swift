//
//  PartyEvaluationViewController.swift
//  Politics NI
//
//  Created by App Camp on 04/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
import Social

class PartyEvaluationViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    lazy var partiesRef = FIRDatabase.database().reference().child("parties").child("party")
    var parties = [Party]()
    var partyEval = [PartyEval]()
    var chosenRow: Int!
    var equal = false
    var equalDone = false
    var extraRows = 0
    var rowLimit = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        equal = false
        equalDone = false
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            //self.tableView.rowHeight = 150
                self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
        
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        
        
        partiesRef.keepSynced(true)
        partiesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
                
                let id = childSnapshot.value!.objectForKey("PartyOrganisationId") as! String
                let email = childSnapshot.value!.objectForKey("email") as! String
                let logo = childSnapshot.value!.objectForKey("logo") as! String
                let name = childSnapshot.value!.objectForKey("name") as! String
                let phoneNum = childSnapshot.value!.objectForKey("phoneNum") as! String
                let webLink = childSnapshot.value!.objectForKey("webLink") as! String
                let twitter = childSnapshot.value!.objectForKey("twitter") as! String
                let party = Party(id: id, name: name, logo: logo, webLink: webLink, twitterLink: twitter, phoneNum: phoneNum, email: email)
                self.parties.append(party)
                self.partyEval.append(PartyEval(partyID: party.id, score: 0, numViewsAns: 0))
            }
            self.rankParties()
            self.parties = self.sortParties()
            self.tableView.reloadData()
        })

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let entry = parties[indexPath.row]
        
        var cmpPartyEval1: PartyEval!
        var cmpPartyEval2: PartyEval!
        
        equal = false
        
        if (indexPath.row > 2) && (!equalDone) {
            for party in partyEval {
                if party.partyID == entry.id {
                    cmpPartyEval1 = party
                } else if parties[indexPath.row-1].id == party.partyID {
                    cmpPartyEval2 = party
                }
            }
            if (cmpPartyEval1.percent == cmpPartyEval2.percent) {
                equal = true
                extraRows = extraRows + 1
            } else {
                equal = false
                equalDone = true
                rowLimit = rowLimit + extraRows
            }
        }
    
        
        if (indexPath.row <= rowLimit) || (equal) {
            let topCell = tableView.dequeueReusableCellWithIdentifier("topCell", forIndexPath: indexPath) as! PartyEvalTopCellViewController
            topCell.backgroundColor = UIColor(red:0.30, green:0.59, blue:0.96, alpha:1.0)
            topCell.partyLogo.image = UIImage(named: entry.logo)
            topCell.partyName.text = entry.name
            
            if (indexPath.row >= 1) {
                for party in partyEval {
                    if party.partyID == entry.id {
                        cmpPartyEval1 = party
                    } else if parties[indexPath.row-1].id == party.partyID {
                        cmpPartyEval2 = party
                    }
                }
                
                if (cmpPartyEval1.percent == cmpPartyEval2.percent) {
                    equal = true

                }
            }
        
        if (equal) || ((indexPath.row > 2) && (indexPath.row <= rowLimit)) {
            topCell.rank.text = "="
        } else {
            topCell.rank.text = String(indexPath.row + 1)
        }

        
            for party in partyEval {
                for partyt in parties {
                    if (party.partyID == partyt.id) {
                        if (partyt.id == entry.id) {
                        if (party.percent >= 0.90) {
                            topCell.partyEvaluation.text = "Strongly agree on issues"
                        } else if (party.percent >= 0.75) {
                            topCell.partyEvaluation.text = "Mostly agree on issues"
                        } else if (party.percent > 0.50) {
                            topCell.partyEvaluation.text = "Generally agree on issues"
                        } else if (party.percent >= 0.45) {
                            topCell.partyEvaluation.text = "Balanced on agreement on issues"
                        } else if (party.percent >= 0.25) {
                            topCell.partyEvaluation.text = "Mostly disagree on issues"
                        } else {
                            topCell.partyEvaluation.text = "Strongly disagree on issues"
                        }
                        }
                    }
                }
            }
            return topCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! PartyEvalCellViewController
            let image = UIImage(named: entry.logo)
            cell.partyLogo.image = image
            cell.partyName.text = entry.name
            
            
                for party in partyEval {
                    if party.partyID == entry.id {
                        cmpPartyEval1 = party
                    } else if parties[indexPath.row-1].id == party.partyID {
                        cmpPartyEval2 = party
                    }
                }
            
            if (cmpPartyEval1.percent == cmpPartyEval2.percent) {
                    cell.rank.text = "="
            } else {
                cell.rank.text = String(indexPath.row + 1)
            }

            
            for party in partyEval {
                    for partyt in parties {
                        if (party.partyID == partyt.id) {
                            if (partyt.id == entry.id) {
                                if (party.percent >= 0.90) {
                                    cell.partyPercent.text = "Strongly agree on issues"
                                } else if (party.percent >= 0.75) {
                                    cell.partyPercent.text = "Mostly agree on issues"
                                } else if (party.percent > 0.50) {
                                    cell.partyPercent.text = "Generally agree on issues"
                                } else if (party.percent >= 0.45) {
                                    cell.partyPercent.text = "Balanced on agreement on issues"
                                } else if (party.percent >= 0.25) {
                                    cell.partyPercent.text = "Mostly disagree on issues"
                                } else {
                                    cell.partyPercent.text = "Strongly disagree on issues"
                                }
                            }
                        }
                }
                }
            return cell
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func rankParties() {
        let userRespondedIssues = userUtility.issues
        let agreeViews = userUtility.agreeViews
        let disagreeViews = userUtility.disagreeViews
        let neutralViews = userUtility.neutralViews
        
        for issue in userRespondedIssues {
            for view in agreeViews {
                if (view.issueID == issue.id) {
                    for party in partyEval.enumerate() {
                        if (party.element.partyID == view.partyID) {
                            self.partyEval[party.index].numViewsAns! += 1
                            self.partyEval[party.index].score! += 1
                            self.partyEval[party.index].percent = self.partyEval[party.index].score!/self.partyEval[party.index].numViewsAns!
                        }
                    }
                }
            }
            
            for view in disagreeViews {
                if (view.issueID == issue.id) {
                    for party in partyEval.enumerate() {
                        if (party.element.partyID == view.partyID) {
                            self.partyEval[party.index].numViewsAns! += 1
                            self.partyEval[party.index].percent = self.partyEval[party.index].score!/self.partyEval[party.index].numViewsAns!
                        }
                    }
                }
            }
            
            for view in neutralViews {
                if (view.issueID == issue.id) {
                    for party in partyEval.enumerate() {
                        if (party.element.partyID == view.partyID) {
                            self.partyEval[party.index].numViewsAns! += 1
                            self.partyEval[party.index].score! += 0.5
                            self.partyEval[party.index].percent = self.partyEval[party.index].score!/self.partyEval[party.index].numViewsAns!
                        }
                    }
                }
            }
        }
        var partyEvalVerif = [PartyEval]()
        for party in self.partyEval.enumerate() {
            if party.element.percent != nil {
                partyEvalVerif.append(party.element)
            }
        }
        
        self.partyEval = partyEvalVerif
    }
    
    
    func sortParties() -> [Party] {
        let partyEvalsorted = partyEval.sort {$0.percent > $1.percent}
        var sortedParties =  [Party]()
        
        for partyE in partyEvalsorted  {
            for party in parties {
                if (partyE.partyID == party.id) && (partyE.numViewsAns >= 3) {
                    sortedParties.append(party)
                }
            }
        }
        return sortedParties
        }
    
    @IBAction func shareSocialMedia(sender: AnyObject) {
        let screen = UIScreen.mainScreen()
        
        if let window = UIApplication.sharedApplication().keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet.setInitialText("I now know what party represents my views using Politics NI, available on the iOS appstore.")
            composeSheet.addImage(image)
            
            presentViewController(composeSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareTwitter(sender: UIBarButtonItem) {
        let screen = UIScreen.mainScreen()
        
        if let window = UIApplication.sharedApplication().keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeSheet.setInitialText("I now know what party represents my views using Politics NI, available on the iOS appstore.")
            composeSheet.addImage(image)
            
            presentViewController(composeSheet, animated: true, completion: nil)
    }
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row <= 2 || equal {
            return 120
        }
        else {
            return 100
        }
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView) -> NSAttributedString? {
        let str = "You have not responded to enough issues. Please respond to more issues."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chosenRow = indexPath.row
        performSegueWithIdentifier("goToPartyViewEvaluation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToPartyViewEvaluation" {
            let desView = segue.destinationViewController as! PartyEvalAgreeDisagreeViewController
            desView.party = parties[chosenRow]
        }
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "evalstack")!
    }

    

}
