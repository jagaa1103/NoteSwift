//
//  ViewController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/8/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import Parse

class RegisterPageController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var repasswordInput: UITextField!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.indicator)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okClicked(sender: AnyObject) {
        println("username: \(usernameInput.text)")
        println("email: \(emailInput.text)")
        
        var username = usernameInput.text
        var email = emailInput.text
        var password = passwordInput.text
        var repassword = repasswordInput.text
        
        if(!username.isEmpty && !email.isEmpty && !password.isEmpty && !repassword.isEmpty){
            if(password == repassword){
                self.indicator.startAnimating()
                var newUser = PFUser()
                newUser.username = username
                newUser.email = email
                newUser.password = password

                newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.indicator.stopAnimating()
                    if(error != nil){
                        println(error)
                        var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }else{
                        var alert = UIAlertView(title: "Success", message: "You Signed Up successfully", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })

            }else{
                var alert = UIAlertView(title: "Error", message: "Your password is not match re-password! Please insert match password and re-password", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }else{
            var alert = UIAlertView(title: "Error", message: "Please insert in all field", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    @IBAction func cancelClicked(sender: AnyObject) {
        usernameInput.text = ""
        emailInput.text = ""
        passwordInput.text = ""
        repasswordInput.text = ""
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

