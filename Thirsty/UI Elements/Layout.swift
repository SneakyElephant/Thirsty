//
//  Layout.swift
//
//  Created by Justin Driscoll on 2/22/15.
//  https://gist.github.com/jdriscoll/e773ba25c4692bd6ee15

import UIKit

struct Inset {
    let value: CGFloat
    let attr: NSLayoutAttribute
    
    init(_ value: CGFloat, from attr: NSLayoutAttribute) {
        self.attr = attr;
        switch (attr) {
        case .Right, .Bottom:  self.value = -value
        default: self.value = value
        }
    }
}

extension UIView {
    func addSubviews(views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func layoutRelativeTo(otherView: AnyObject, insets: Inset...) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for inset in insets {
            constraints.append(NSLayoutConstraint(item: self, attribute: inset.attr, relatedBy: NSLayoutRelation.Equal, toItem: otherView, attribute: inset.attr, multiplier: 1.0, constant: inset.value))
        }
        return constraints
    }
    
    func layoutInside(otherView: AnyObject) -> [NSLayoutConstraint] {
        return layoutRelativeTo(otherView, insets: Inset(0, from: .Top), Inset(0, from: .Right), Inset(0, from: .Bottom), Inset(0, from: .Left))
    }
    
    func constrainDimension(dimension: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: dimension, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)]
    }
    
    func constrainDimension(dimension: NSLayoutAttribute, relation: NSLayoutRelation, toView otherView: AnyObject, constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: dimension, relatedBy: relation, toItem: otherView, attribute: dimension, multiplier: 1, constant: constant)]
    }
    
    func constrainWidth(relation: NSLayoutRelation, toWidth constant: CGFloat) -> [NSLayoutConstraint] {
        return constrainDimension(.Width, relation: relation, constant: constant)
    }
    
    func constrainWidth(relation: NSLayoutRelation, toView otherView: AnyObject, plus constant: CGFloat) -> [NSLayoutConstraint] {
        return constrainDimension(.Width, relation: relation, toView: otherView, constant: constant)
    }
    
    func constrainHeight(relation: NSLayoutRelation, toHeight constant: CGFloat) -> [NSLayoutConstraint] {
        return constrainDimension(.Height, relation: relation, constant: constant)
    }
    
    func constrainHeight(relation: NSLayoutRelation, toView otherView: AnyObject, plus constant: CGFloat) -> [NSLayoutConstraint] {
        return constrainDimension(.Height, relation: relation, toView: otherView, constant: constant)
    }
    
    func layoutAbove(otherView: AnyObject, distance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: otherView, attribute: .Top, multiplier: 1, constant: -constant)]
    }
    
    func layoutAbove(otherView: AnyObject, minimumDistance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: otherView, attribute: .Top, multiplier: 1, constant: -constant)]
    }
    
    func layoutBelow(otherView: AnyObject, distance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: otherView, attribute: .Bottom, multiplier: 1, constant: constant)]
    }
    
    func layoutBelow(otherView: AnyObject, minimumDistance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: otherView, attribute: .Bottom, multiplier: 1, constant: constant)]
    }
    
    func layoutBefore(otherView: AnyObject, distance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: otherView, attribute: .Left, multiplier: 1, constant: -constant)]
    }
    
    func layoutBefore(otherView: AnyObject, minimumDistance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: otherView, attribute: .Left, multiplier: 1, constant: -constant)]
    }
    
    func layoutAfter(otherView: AnyObject, distance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: otherView, attribute: .Right, multiplier: 1, constant: constant)]
    }
    
    func layoutAfter(otherView: AnyObject, minimumDistance constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: otherView, attribute: .Right, multiplier: 1, constant: constant)]
    }
    
    func alignWith(otherView: AnyObject, attr: NSLayoutAttribute, offsetBy constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: attr, relatedBy: .Equal, toItem: otherView, attribute: attr, multiplier: 1, constant: constant)]
    }
    
    func alignBaselineWith(otherView: AnyObject, offsetBy constant: CGFloat) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: self, attribute: .Baseline, relatedBy: .Equal, toItem: otherView, attribute: .Baseline, multiplier: 1, constant: constant)]
    }
}

extension Array {
    func withPriority(priority: UILayoutPriority) -> [NSLayoutConstraint] {
        var members: [NSLayoutConstraint] = []
        for member in self {
            switch member {
            case let constraint as NSLayoutConstraint:
                constraint.priority = priority
                members.append(constraint)
            default: break
            }
        }
        return members
    }
}