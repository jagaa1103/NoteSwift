//
//  ViewController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/8/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import Parse

class LoginPageController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseService.sharedInstance.setLoginViewController(self)
        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.indicator)
        self.passwordInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        login()
        return true
    }

    @IBAction func signinClicked(sender: AnyObject) {
        login()
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
    
    func login(){
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
                        ParseService.sharedInstance.checkLogin()
                    }else{
                        var alert = UIAlertView(title: "Error", message: "Please confirm verify your account from your email", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        ParseService.sharedInstance.logout()
                    }
                }else{
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    ParseService.sharedInstance.logout()
                }
            })
        }
    }
}

