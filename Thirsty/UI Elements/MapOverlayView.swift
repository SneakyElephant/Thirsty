//
//  MapOverlayView.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/29/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

class MapOverlayView: UIView {
    //TODO: Add tap gesture recognizer.
    private let scrollView: MapOverlayScrollView
    private var scrollContainerView: UIView //Used to have auto-layout keep the scrollview's content size at double its height.
    private var open: Bool
    var contentView: UIView? = nil {
        willSet (newView) {
            scrollView.slidingView = newView
            if let newView = newView? {
                //Place the new view.
                newView.setTranslatesAutoresizingMaskIntoConstraints(false)
                scrollContainerView.addSubview(newView)
                
                //Match new view's size to our size.
                var constraints: [NSLayoutConstraint] = []
                constraints += newView.constrainDimension(.Height, relation: .Equal, toView: self, constant: 0)
                constraints += newView.constrainDimension(.Width, relation: .Equal, toView: self, constant: 0)
                self.addConstraints(constraints)
                
                //Place the new view at the bottom of the scroll content view.
                constraints = []
                constraints += newView.layoutRelativeTo(scrollContainerView, insets: Inset(0, from: .Bottom), Inset(0, from: .Left))
                scrollContainerView.addConstraints(constraints)
            }
        } didSet (oldView) {
            oldView?.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        let cellHeight = BarDetailView.topCellHeight
        open = false
        scrollView = MapOverlayScrollView(frame: CGRectMake(0, CGFloat(cellHeight), frame.size.width, frame.size.height - CGFloat(cellHeight)))
        scrollContainerView = UIView()
        super.init(frame:frame)
        
        scrollView.pagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(scrollView)
        
        scrollContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.addSubview(scrollContainerView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += scrollView.layoutRelativeTo(self, insets: Inset(CGFloat(cellHeight), from: .Top), Inset(0, from: .Left), Inset(0, from: .Right), Inset(0, from: .Bottom))
        constraints.append(NSLayoutConstraint(item: scrollContainerView, attribute:.Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 2, constant: 0))
        constraints.append(NSLayoutConstraint(item: scrollContainerView, attribute:.Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        addConstraints(constraints)
        
        constraints = []
        constraints += scrollContainerView.layoutInside(scrollView)
        scrollView.addConstraints(constraints)
    }
    
    required init(coder pDecoder: NSCoder) {
        open = false
        scrollView = MapOverlayScrollView()
        scrollContainerView = UIView()
        super.init(coder: pDecoder)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if open {
            return true
        }
        
        var responseRect = scrollView.convertRect(scrollView.slidingView!.frame, toView: scrollView.superview);
        
        return CGRectContainsPoint(responseRect, point);
    }
}

private class MapOverlayScrollView: UIScrollView {
    var slidingView: UIView? = nil
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        //return if the sliding view is not visible
        if  (slidingView?.hidden == nil) {
            return false
        }
        
        //only allow touches that are on our sliding view
        if let slidingViewFrame = slidingView?.frame {
            var parentLocation = convertPoint(point, toView: superview)
            var responseRect = convertRect(slidingViewFrame, toView: superview)
            return CGRectContainsPoint(responseRect, parentLocation)
        }
        
        return false
    }
}