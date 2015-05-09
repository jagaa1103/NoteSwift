//
//  ViewController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/8/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

class RegisterPageController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var repasswordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okClicked(sender: AnyObject) {
        println("username: \(usernameInput.text)")
        println("email: \(emailInput.text)")
        if(passwordInput.text == repasswordInput.text && emailInput.text != "" && usernameInput.text != ""){
            println("password: \(passwordInput.text)")
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            println("password is wrong")
        }
    }
    @IBAction func cancelClicked(sender: AnyObject) {
        usernameInput.text = ""
        emailInput.text = ""
        passwordInput.text = ""
        repasswordInput.text = ""
    }
    
}

