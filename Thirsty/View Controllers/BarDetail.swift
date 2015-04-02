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
    var bar: Bar? {
        willSet (newBar) {
            if let newBar = newBar? {
                barNameLabel.text = newBar.name
                addressLabel.text = newBar.address + " | 0.3 Miles" //test string
            }
        }
    }
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
        
        let externalButtonView = self.externalButtonView()
        let externalButtonViewHeight = 50
        addSubview(externalButtonView)
        
        let photoAndMapView = self.photoAndMapView()
        let photoAndMapViewHeight = 234
        addSubview(photoAndMapView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += topCellView.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Left), Inset(0, from: .Right))
        constraints += topCellView.constrainHeight(.Equal, toHeight: CGFloat(BarDetailView.topCellHeight))
        
        constraints += externalButtonView.layoutRelativeTo(self, insets: Inset(0, from: .Left), Inset(0, from: .Right))
        constraints += externalButtonView.layoutBelow(topCellView, distance: 0)
        constraints += externalButtonView.constrainHeight(.Equal, toHeight: CGFloat(externalButtonViewHeight))
        
        constraints += photoAndMapView.layoutRelativeTo(self, insets: Inset(0, from: .Left), Inset(0, from: .Right))
        constraints += photoAndMapView.layoutBelow(externalButtonView, distance: 0)
        constraints += photoAndMapView.constrainHeight(.Equal, toHeight: CGFloat(photoAndMapViewHeight))
        
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
        topCellView.backgroundColor = UIColor.backgroundColor()
        
        let topSpacer = UIView()
        topSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
        topCellView.addSubview(topSpacer)
        
        barNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        barNameLabel.font = UIFont.titleFont()
        barNameLabel.textColor = UIColor.whiteColor()
        topCellView.addSubview(barNameLabel)
        
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
    
    func externalButtonView() -> UIView {
        let dividerPadding = 5
        let externalButtonView = UIView()
        externalButtonView.setTranslatesAutoresizingMaskIntoConstraints(false)
        externalButtonView.backgroundColor = UIColor.buttonColor()
        
        let directionsButton = ExternalButton()
        directionsButton.label.text = "Directions" //test value
        directionsButton.imageView.image =  UIImage(named: "DirectionsIcon")
        directionsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        externalButtonView.addSubview(directionsButton)
        
        let leftDivider = UIView()
        leftDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftDivider.backgroundColor = UIColor.backgroundColor()
        externalButtonView.addSubview(leftDivider)
        
        let phoneButton = ExternalButton()
        phoneButton.label.text = "347-844-0594" //test value
        phoneButton.imageView.image =  UIImage(named: "PhoneIcon")
        phoneButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        externalButtonView.addSubview(phoneButton)
        
        let rightDivider = UIView()
        rightDivider.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightDivider.backgroundColor = UIColor.backgroundColor()
        externalButtonView.addSubview(rightDivider)
        
        let websiteButton = ExternalButton()
        websiteButton.label.text = "Website" //test value
        websiteButton.imageView.image =  UIImage(named: "WebIcon")
        websiteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        externalButtonView.addSubview(websiteButton)
        
        var constraints: [NSLayoutConstraint] = []
        
        //constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[dir][d1(1)][phone][d2(1)][web]|", options: .AlignAllTop, metrics: nil, views: ["dir": directionsButton,"d1": leftDivider, "phone": phoneButton, "d2": rightDivider, "web": websiteButton]) as [NSLayoutConstraint]
        constraints += directionsButton.layoutRelativeTo(externalButtonView, insets: Inset(0, from: .Left), Inset(0, from: .Top), Inset(0, from: .Bottom))
        constraints += directionsButton.constrainWidth(.Equal, toView: phoneButton, plus: 0)
        
        constraints += leftDivider.layoutAfter(directionsButton, distance: 0)
        constraints += leftDivider.layoutRelativeTo(externalButtonView, insets: Inset(CGFloat(dividerPadding), from: .Top), Inset(CGFloat(dividerPadding), from: .Bottom))
        constraints += leftDivider.constrainWidth(.Equal, toWidth: 1)
        
        constraints += phoneButton.layoutAfter(leftDivider, distance: 0)
        constraints += phoneButton.constrainWidth(.Equal, toView: directionsButton, plus: 0)
        constraints += phoneButton.layoutRelativeTo(externalButtonView, insets: Inset(0, from: .Top), Inset(0, from: .Bottom))
        
        constraints += rightDivider.layoutAfter(phoneButton, distance: 0)
        constraints += rightDivider.layoutRelativeTo(externalButtonView, insets: Inset(CGFloat(dividerPadding), from: .Top), Inset(CGFloat(dividerPadding), from: .Bottom))
        constraints += rightDivider.constrainWidth(.Equal, toWidth: 1)
        
        constraints += websiteButton.layoutAfter(rightDivider, distance: 0)
        constraints += websiteButton.constrainWidth(.Equal, toView: directionsButton, plus: 0)
        constraints += websiteButton.layoutRelativeTo(externalButtonView, insets: Inset(0, from: .Right), Inset(0, from: .Top), Inset(0, from: .Bottom))
        
        externalButtonView.addConstraints(constraints)
        
        return externalButtonView
    }
    
    func photoAndMapView() -> UIView {
        let photoAndMapView = UIView()
        photoAndMapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        photoAndMapView.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TestPhotoOne")
        imageView.contentMode = .ScaleAspectFill
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.clipsToBounds = true
        photoAndMapView.addSubview(imageView)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += imageView.layoutInside(photoAndMapView)
        
        photoAndMapView.addConstraints(constraints)
        
        return photoAndMapView
    }
}
