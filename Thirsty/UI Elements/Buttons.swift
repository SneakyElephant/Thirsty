//
//  Buttons.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/31/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

class FavoriteButton: UIControl {
    let imageView: UIImageView
    
    override init() {
        imageView = UIImageView()
        super.init()
        
        imageView.image = UIImage(named: "HeartEmpty")
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = UIViewContentMode.Center
        self.addSubview(imageView)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += imageView.layoutInside(self)
        
        addConstraints(constraints)
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame:frame)
    }
    
    required init(coder pDecoder: NSCoder) {
        imageView = UIImageView()
        super.init(coder: pDecoder)
    }
}
