//
//  ViewController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/8/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import Parse

class LoginPageController: UIViewController{

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.indicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func signinClicked(sender: AnyObject) {
        println("username: \(usernameInput.text)")
        println("password: \(passwordInput.text)")
        var username = usernameInput.text
        var password = passwordInput.text
        if(username == "" || password == ""){
            var alert = UIAlertView(title: "Login Error", message: "Please Insert username/password", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
            self.indicator.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: {
                (user, error) -> Void in
                self.indicator.stopAnimating()

                if(user != nil){
                    var emailVerify = user!.objectForKey("emailVerified") as! NSNumber
                    println(emailVerify)
                    if(emailVerify == 1){
                        var alert = UIAlertView(title: "Success", message: "Your login is successful", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        var alert = UIAlertView(title: "Error", message: "Please confirm verify your account from your email", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        self.logOut()
                    }
                }else{
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.logOut()
                }
            })
        }
    }
    
    func logOut(){
        PFUser.logOut()
    }
    
    @IBAction func signupClicked(sender: AnyObject) {
        usernameInput.text = ""
        passwordInput.text = ""
        println("go to RegisterPage")
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterPage") as! RegisterPageController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

