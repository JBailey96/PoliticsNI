//
//  AboutViewController.swift
//  Politics NI
//
//  Created by App Camp on 21/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//


class AboutViewController: UITableViewController {
    
    var showAbout = false
    var showViews = false
    var showImagery = false
    var showInfo = false
    var showLegal = false
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1) {
            if showAbout {
                showAbout = false
            } else {
               showAbout = true
            }
        } else if (indexPath.row == 3) {
            if showViews {
                showViews = false
            } else {
                showViews = true
            }
        } else if (indexPath.row == 5) {
            if showImagery {
                showImagery = false
            } else {
                showImagery = true
            }
        } else if (indexPath.row == 7) {
            if showInfo {
                showInfo = false
            } else {
                showInfo = true
            }
        } else if (indexPath.row == 9) {
            if showLegal {
                showLegal = false
            } else {
                showLegal = true
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 146
        } else if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 {
            return UITableViewAutomaticDimension
        }
        if (indexPath.row == 2) && showAbout {
            return 220
        }
        if (indexPath.row == 4) && showViews {
            return 220
        }
        if (indexPath.row == 6) && showImagery {
            return 220
        }
        if (indexPath.row == 8) && showInfo {
            return 220
        }
        if (indexPath.row == 10) && showLegal {
            return 220
        }
        return 0
    }
    
    

    
    
}
