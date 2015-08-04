//
//  SideMenu.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/10/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

@objc protocol SideMenuDelegate{
    func didSelectSideMenuRow(indexPath:NSIndexPath)
    optional func sideBarWillClose()
    optional func sideBarWillOpen()
}

class SideMenu: NSObject, SideMenuDelegate {
    
    let barWidth:CGFloat = 200.0
    let sideBarTableTopInset:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideBarFooter:UIView = UIView()
    let sideMenuTable:SideMenuTable = SideMenuTable()
    var originView:UIView?
    
    var animator:UIDynamicAnimator!
    var delegate: SideMenuDelegate?
    var isSideMenuOpen:Bool = false
    
    override init(){
        super.init()
    }
    
    init(sourceView:UIView) {
        super.init()
        originView = sourceView
        
        setupSideMenu()
        
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);
        sideMenuTable.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None);
        sideMenuTable.tableView(sideMenuTable.tableView, didSelectRowAtIndexPath: rowToSelect);
        didSelectSideMenuRow(rowToSelect)
        animator = UIDynamicAnimator(referenceView: originView!)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView!.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView!.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    func setupSideMenu(){
        sideBarContainerView.frame = CGRectMake(0 , originView!.frame.origin.y, barWidth, originView!.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        originView!.addSubview(sideBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        buildTable()
        sideMenuTable.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideMenuTable.tableView)
        sideBarFooter.frame = CGRectMake(0 , sideBarContainerView.frame.height-40, sideBarContainerView.frame.width, 40)
        sideBarFooter.backgroundColor = UIColor.brownColor()
        
        let imageName = "settings.png"
        let image = UIImage(named: imageName)
        let settingsBtn = UIButton()
        settingsBtn.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        settingsBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        settingsBtn.addTarget(self, action: "settingsBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)

        sideBarFooter.addSubview(settingsBtn)
        
        sideBarContainerView.addSubview(sideBarFooter)

    }
    
    func buildTable(){
        ParseService.sharedInstance.getNotes{res in
            self.sideMenuTable.tableData = res
        }
        sideMenuTable.delegate = self
        sideMenuTable.tableView.frame = CGRectMake(0 , originView!.frame.origin.y, sideBarContainerView.frame.width, sideBarContainerView.frame.height - 40)
        sideMenuTable.tableView.clipsToBounds = false
        sideMenuTable.tableView.backgroundColor = UIColor.clearColor()
        sideMenuTable.tableView.scrollsToTop = false
        sideMenuTable.tableView.separatorColor = UIColor.clearColor()
        sideMenuTable.tableView.contentInset = UIEdgeInsetsMake(sideBarTableTopInset, 0, 0, 0)
    }
    
    func removeTable(){
        sideMenuTable.removeFromParentViewController()
    }
    
    func didSelectSideMenuRow(indexPath: NSIndexPath) {
        delegate?.didSelectSideMenuRow(indexPath)
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Left{
            showSideMenu(false)
            delegate?.sideBarWillClose?()
        }else{
            showSideMenu(true)
            delegate?.sideBarWillOpen?()
        }
    }
    
    func showSideMenu(shouldOpen: Bool){
        animator.removeAllBehaviors()
        isSideMenuOpen = shouldOpen
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude:CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravityBehavior:UIGravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior:UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundaryWithIdentifier("SideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView!.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
    }
    
    func settingsBtnClicked(sender:UIButton!){
        println("Settings Button Clicked!!!")
        ParseService.sharedInstance.logout()
    }
}
