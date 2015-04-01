//
//  Buttons.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/31/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

class ThirstyButton: UIControl {
    let label = UILabel()
    let imageView = UIImageView()
    
    override init() {
        super.init()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(imageView)
        
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.buttonFont()
        self.addSubview(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    func touchesBegan() {
        label.alpha = 0.5
        imageView.alpha = 0.5
    }
    
    func touchesEnded() {
        label.alpha = 1
        imageView.alpha = 1
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent:  event)
        touchesBegan()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        touchesEnded()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        touchesEnded()
    }
}

class FavoriteButton: ThirstyButton {
    override init() {
        super.init()
        
        imageView.image = UIImage(named: "HeartEmpty")
        imageView.contentMode = UIViewContentMode.Center
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += imageView.layoutInside(self)
        
        addConstraints(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
}

class ExternalButton: ThirstyButton {
    override init() {
        super.init()
        let gapBetweenImageAndLabel = 5
        
        let leftSpacer = UIView()
        leftSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(leftSpacer)
        
        imageView.contentMode = UIViewContentMode.Center
        
        label.textAlignment = .Center
        
        let rightSpacer = UIView()
        rightSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(rightSpacer)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += leftSpacer.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Left), Inset(0, from: .Bottom))
        constraints += imageView.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Bottom))
        constraints += imageView.layoutAfter(leftSpacer, distance: 0)
        constraints += label.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Bottom))
        constraints += label.layoutAfter(imageView, distance: CGFloat(gapBetweenImageAndLabel))
        constraints += rightSpacer.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Right), Inset(0, from: .Bottom))
        constraints += rightSpacer.constrainWidth(.Equal, toView: leftSpacer, plus: 0)
        constraints += rightSpacer.layoutAfter(label, distance: 0)
        
        addConstraints(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
}
