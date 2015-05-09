//
//  ViewController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/8/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

class LoginPageController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signinClicked(sender: AnyObject) {
        println("username: \(usernameInput.text)")
        println("password: \(passwordInput.text)")
    }
    @IBAction func signupClicked(sender: AnyObject) {
        usernameInput.text = ""
        passwordInput.text = ""
        println("go to RegisterPage")
//        let vc = RegisterPageController() //change this to your class name
//        self.presentViewController(vc, animated: true, completion: nil)
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterPage") as! RegisterPageController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

