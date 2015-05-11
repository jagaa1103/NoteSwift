//
//  SideMenu.swift
//  NoteSwift
//
//  Created by Enkhjargal Gansukh on 5/10/15.
//  Copyright (c) 2015 Enkhjargal Gansukh. All rights reserved.
//

import UIKit

class SideMenu: NSObject, SideMenuDelegate {
    
    let barWidth:CGFloat = 150.0
    let sideBarTableTopInset:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideMenuTable:SideMenuTable = SideMenuTable()
    let originView:UIView!
    
    var animator:UIDynamicAnimator!
    var delegate: SideMenuDelegate?
    var isSideMenuOpen:Bool = false
    
    override init(){
        super.init()
    }
    
    init(sourceView:UIView, menuItems:Array<String>) {
        super.init()
        originView = sourceView
        sideMenuTable.tableData = menuItems
        
        setupSideMenu()
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    func setupSideMenu(){
        sideBarContainerView.frame = CGRectMake(-barWidth - 1 , originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBarContainerView.backgroundColor = UIColor.clearColor()
        sideBarContainerView.clipsToBounds = false
        originView.addSubview(sideBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        sideMenuTable.delegate = self
        sideMenuTable.tableView.frame = sideBarContainerView.bounds
        sideMenuTable.tableView.clipsToBounds = false
        sideMenuTable.tableView.backgroundColor = UIColor.clearColor()
        sideMenuTable.tableView.scrollsToTop = false
        sideMenuTable.tableView.contentInset = UIEdgeInsetsMake(sideBarTableTopInset, 0, 0, 0)
        sideMenuTable.tableView.reloadData()
        sideBarContainerView.addSubview(sideMenuTable.tableView)
    }
    
    
    func didSelectSideMenuRow(indexPath: NSIndexPath) {
        delegate?.didSelectSideMenuRow(indexPath.row)
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
        collisionBehavior.addBoundaryWithIdentifier("SideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
        
    }
}
