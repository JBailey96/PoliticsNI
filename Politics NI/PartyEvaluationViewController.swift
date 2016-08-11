//
//  PartyEvaluationViewController.swift
//  Politics NI
//
//  Created by App Camp on 04/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
import Social

class PartyEvaluationViewController: UITableViewController {
    lazy var partiesRef = FIRDatabase.database().reference().child("parties").child("party")
    var parties = [Party]()
    var partyEval = [PartyEval]()

    override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.rowHeight = 111
                self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
            self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
        
        self.navigationController?.navigationBar.backItem?.title
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
            loadParties()
    }
    
    func loadParties() {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! PartyEvalCellViewController
        let entry = parties[indexPath.row]
        let image = UIImage(named: entry.logo)
        cell.partyLogo.image = image
        cell.partyName.text = entry.name
        
        for party in partyEval {
            if (party.percent != nil) {
                if (party.partyID == entry.id) {
                    if (party.percent >= 0.75) {
                        cell.partyPercent.text = "Strongly agree on issues"
                    } else if (party.percent >= 0.50) {
                        cell.partyPercent.text = "Mostly agree on issues"
                    } else if (party.percent >= 0.25) {
                        cell.partyPercent.text = "Mostly disagree on issues"
                    } else if (party.percent >= 0) {
                        cell.partyPercent.text = "Strongly disagree on issues"
                    }
                }
            } else {
                cell.partyPercent.text = "Not enough information."
            }
        }
        return cell
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
    }
    
    
    func sortParties() -> [Party] {
        let partyEvalsorted = partyEval.sort {$0.percent > $1.percent}
        
        var sortedParties =  [Party]()
        
        for partyE in partyEvalsorted  {
            for party in parties {
                if (partyE.partyID == party.id) {
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
}
