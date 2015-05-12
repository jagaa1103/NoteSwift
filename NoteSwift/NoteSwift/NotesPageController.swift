//
//  NotesPageController.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/9/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import Parse

class NotesPageController: UIViewController, UITextViewDelegate, SideMenuDelegate{
   
    var sideMenu:SideMenu = SideMenu()
    var notes: Array<String> = []
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    @IBOutlet var newWordField: UITextField?
    @IBOutlet weak var NoteView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.center = self.view.center
        self.indicator.hidesWhenStopped = true
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.indicator)
        self.indicator.startAnimating()
        self.NoteView.delegate = self
        if ParseService.sharedInstance.checkLogin(){
            ParseService.sharedInstance.getNotes{
                res in
                println("View Controller: \(res)")
                self.notes = res
                self.sideMenu = SideMenu(sourceView: self.view, menuItems: self.notes)
                self.sideMenu.delegate = self
                self.indicator.stopAnimating()
            }
        }else{
            self.indicator.stopAnimating()
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPage") as! LoginPageController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newNoteClicked(sender: AnyObject) {
        
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        self.newWordField = textField
    }


    func saveNote(){
        println("Saving your note...")
        var currentUser = PFUser.currentUser()
        
        var noteObject = PFObject(className:"Notes")
        noteObject["username"] = currentUser?.username
        noteObject["note"] = self.newWordField!.text
        noteObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("note is saved... \(success)")
                noteObject.fetch()
                self.getNotes()
            } else {
                // There was a problem, check error.description
                println("note is not saved... \(error)")
            }
        }

    }
    
    func getNotes(){
        var currentUser = PFUser.currentUser()
        var query = PFQuery(className:"Notes")
        query.whereKey("username", equalTo:currentUser!.username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            self.notes.removeAll(keepCapacity: false)
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) notes.")
                println("Successfully retrieved: \(objects!) notes.")
                var noteObjects: AnyObject = objects as! AnyObject
                println("noteObjects: \(noteObjects)")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var note = object.objectForKey("note") as! String
                        self.notes.append(note)
                    }
                }
                println(self.notes)
                self.NoteView.text = self.notes[self.notes.count - 1]
                self.sideMenu = SideMenu(sourceView: self.view, menuItems: self.notes)
                self.sideMenu.delegate = self
                self.indicator.stopAnimating()
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func didSelectSideMenuRow(indexPath: NSIndexPath) {
        println(indexPath.row)
        println("selected note: \(notes[indexPath.row])")
        NoteView.text = notes[indexPath.row]
        self.sideMenu.showSideMenu(false)
        self.sideMenu.delegate?.sideBarWillClose?()
        println("selected note2: \(NoteView.text)")
    }
    
    func logout(){
        PFUser.logOut()
        if ParseService.sharedInstance.checkLogin() {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPage") as! LoginPageController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func addNote(){
        // Create the alert controller
        var alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            ParseService.sharedInstance.saveNote(self.newWordField!.text)
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            println("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func sideBarWillOpen(){
        println("sideBarWillOpen")
        self.NoteView.resignFirstResponder()
    }
    func sideBarWillClose(){
        println("sideBarWillClose")
        self.NoteView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        println("TExt is edited...")
        self.sideMenu.showSideMenu(false)
        self.sideMenu.delegate?.sideBarWillClose?()
        return true
    }
}
