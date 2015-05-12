//
//  parseService.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/11/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import Foundation
import Parse


class ParseService: NSObject {
    
    var currentUser: PFUser?
    var allNotes: Array<String> = []
    
    class var sharedInstance: ParseService {
        struct Static {
            static var instance: ParseService?
        }
        
        if (Static.instance == nil) {
            Static.instance = ParseService()
        }
        
        return Static.instance!
    }
    override init(){
        super.init()
    }
    
    
    func checkLogin()-> Bool{
        currentUser = PFUser.currentUser()
        if (currentUser != nil){
            println("You are already login!!!")
            return true
        } else {
            println("You are not login yet!!!")
            return false
        }
    }
    
    func getNotes(completionHandler: (Array<String>) -> ()){
        var currentUser = PFUser.currentUser()
        var query = PFQuery(className:"Notes")
        query.whereKey("username", equalTo:currentUser!.username!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            self.allNotes.removeAll(keepCapacity: false)
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) notes.")
                println("Successfully retrieved: \(objects!) notes.")
                var noteObjects: AnyObject = objects as! AnyObject
                println("noteObjects: \(noteObjects)")
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var note = object.objectForKey("note") as! String
                        self.allNotes.append(note)
                    }
                }
                completionHandler(self.allNotes)
//                return self.allNotes
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
//                return nil
            }
        }
    }
       
    func saveNote(note:String){
        println("Saving your note...")
        var currentUser = PFUser.currentUser()
        
        var noteObject = PFObject(className:"Notes")
        noteObject["username"] = currentUser?.username
        noteObject["note"] = note
        noteObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("note is saved... \(success)")
                noteObject.fetch()
            } else {
                // There was a problem, check error.description
                println("note is not saved... \(error)")
            }
        }
    }

    func updateNote(){
        
    }
}