//
//  SideMenu.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/10/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

@objc protocol SideMenuTableDelegate{
    func sideMenuTableDidSelectRow(indexPath:NSIndexPath)
}

class SideMenuTable: UITableViewController {

    var delegate: SideMenuDelegate?
    var tableData: Array<String> = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell

        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkTextColor()
            
            let selectedCell: UIView = UIView(frame: CGRect(x:0, y:0, width:cell!.frame.size.width, height: cell!.frame.size.height))
            selectedCell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedCell
        }
        cell!.textLabel?.text = tableData[indexPath.row]

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectSideMenuRow(indexPath)
    }

}
