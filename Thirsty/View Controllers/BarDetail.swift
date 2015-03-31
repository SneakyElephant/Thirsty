//
//  BarDetail.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/30/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

class BarDetailView: UIView {
    let barNameLabel = UILabel()
    let addressLabel = UILabel()
    let favoriteButton = FavoriteButton()
    class var topCellHeight: Float {
        get {
            return 60
        }
    }
    
    override init() {
        super.init()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor.backgroundColor()
        
        let topCellView = self.topCellView()
        addSubview(topCellView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += topCellView.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Left), Inset(0, from: .Right))
        constraints += topCellView.constrainHeight(.Equal, toHeight: CGFloat(BarDetailView.topCellHeight))
        addConstraints(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    func topCellView() -> UIView {
        let sideSpace = 20
        let favoriteButtonWidth = BarDetailView.topCellHeight
        let topCellView = UIView()
        topCellView.setTranslatesAutoresizingMaskIntoConstraints(false)
        topCellView.backgroundColor = UIColor.selectedColor()
        
        let topSpacer = UIView()
        topSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        topCellView.addSubview(topSpacer)
        
        barNameLabel.text = "Industry" //test value
        barNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        barNameLabel.font = UIFont.titleFont()
        barNameLabel.textColor = UIColor.whiteColor()
        topCellView.addSubview(barNameLabel)
        
        addressLabel.text = "1337 12th Street | 0.3 Miles Away" //test value
        addressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addressLabel.font = UIFont.bodyFont()
        addressLabel.textColor = UIColor.whiteColor()
        topCellView.addSubview(addressLabel)
        
        let bottomSpacer = UIView()
        bottomSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        topCellView.addSubview(bottomSpacer)
        
        favoriteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        topCellView.addSubview(favoriteButton)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[sp1][bar][address][sp2(sp1)]|", options: .AlignAllLeading, metrics: nil, views: ["sp1":topSpacer,"bar": barNameLabel, "address":addressLabel, "sp2":bottomSpacer]) as [NSLayoutConstraint]
        constraints += addressLabel.layoutRelativeTo(topCellView, insets: Inset(CGFloat(sideSpace), from: .Left))
        constraints += favoriteButton.layoutRelativeTo(topCellView, insets: Inset(0, from: .Right), Inset(0, from: .Top), Inset(0, from: .Bottom))
        constraints += favoriteButton.constrainWidth(.Equal, toWidth: CGFloat(favoriteButtonWidth))
        
        topCellView.addConstraints(constraints)
        
        return topCellView
    }
}
