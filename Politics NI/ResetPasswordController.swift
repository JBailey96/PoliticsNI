//
//  ResetPasswordController.swift
//  Politics NI
//
//  Created by App Camp on 10/08/2016.
//  Copyright © 2016 App Camp. All rights reserved.
//

import Firebase
import SCLAlertView

class ResetPasswordController: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.19, green:0.53, blue:0.96, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
    }
    @IBAction func sendReset(sender: AnyObject) {
        let email = emailField.text
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
            if let error = error {
                SCLAlertView().showError("Error with reset", subTitle: "Email not recognised. Have you created an account?")
            } else {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false // hide default button
                )
                let alert = SCLAlertView(appearance: appearance) // create alert with appearance
                alert.addButton("OK", action: { // create button on alert
                    self.performSegueWithIdentifier("resetEmailComplete", sender: nil)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                alert.showSuccess("Success", subTitle: "A verification email has been sent.")
            }
        }
    }
    
    func alert(alertDesc: String) {
        let alert = UIAlertController(title: "Alert", message: alertDesc, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }

}
