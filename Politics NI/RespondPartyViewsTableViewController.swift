//
//  RespondPartyViewsTableViewController.swift
//  Politics NI
//
//  Created by App Camp on 09/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase

class RespondPartyViewsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var partyViews = [PartyView]()
    var agreeViews =  [PartyView]()
    var disagreeViews =  [PartyView]()
    var unsureViews = [PartyView]()
    var neutralViews = [PartyView]()
    
    var viewDoneButton = false
    var issues = [Issue]()
    
    var agreeViewsSorted =  [PartyView]()
    var disagreeViewsSorted =  [PartyView]()
    var unsureViewsSorted = [PartyView]()
    var neutralViewsSorted = [PartyView]()
    
    var opinions =  [String]()
    var parties = [Party]()
    
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var done: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Your Responses"
        super.viewDidLoad()
        //opinions.removeAll()
        //chooseOpinion()
        
        if (!viewDoneButton) {
            done.tintColor = UIColor.clearColor()
            done.enabled = false
        } else {
            done.tintColor = UIColor.whiteColor()
            done.enabled = true
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
        
        let attrs = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),]
        self.navigationController!.navigationBar.titleTextAttributes = attrs
        
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            
            let uidRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
            let issueResp = uidRef.child("issueResponses")
            var issuesinBlock = [Issue]()
            var agreeinBlock =  [PartyView]()
            var disagreeinBlock = [PartyView]()
            var unsureinBlock = [PartyView]()
            var neutralinBlock = [PartyView]()
            
            let semaphore = dispatch_semaphore_create(0)
            issueResp.observeSingleEventOfType(.Value, withBlock: { snapshot in
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    let issueDesc = childSnapshot.value?.objectForKey("issueDesc") as! String
                    let issueID = childSnapshot.value?.objectForKey("issueID") as! String
                    let issue = Issue(desc: issueDesc, id: issueID)
                    issuesinBlock.append(issue)
                    
                    var viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Agree")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        agreeinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Disagree")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        disagreeinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Neutral")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        neutralinBlock.append(partyView)
                    }
                    
                    viewsChild = snapshot.childSnapshotForPath(issue.id).childSnapshotForPath("partyViews").childSnapshotForPath("Unsure")
                    for child in viewsChild.children {
                        let childSnapshot = viewsChild.childSnapshotForPath(child.key)
                        let partyID = childSnapshot.value!.objectForKey("partyID") as! String
                        let view = childSnapshot.value!.objectForKey("view") as! String
                        let viewsrc = childSnapshot.value!.objectForKey("viewsrc") as! String
                        let partyView = PartyView(issueID: issue.id, issueDesc: issue.desc, partyID: partyID, view: view, viewsrc: viewsrc)
                        unsureinBlock.append(partyView)
                    }
                }
                self.issues = issuesinBlock
                self.agreeViews =  agreeinBlock
                self.disagreeViews = disagreeinBlock
                self.unsureViews = unsureinBlock
                self.neutralViews = neutralinBlock
                
                dispatch_semaphore_signal(semaphore)
                }, withCancelBlock:  { error in
                    print(error.description)
                }
                
            )
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            self.chooseOpinion()
        }
        viewDoneButton = false
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
        tableView.reloadData()
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
