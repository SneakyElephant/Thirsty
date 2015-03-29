//
//  Favorites.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/29/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    //MARK: Setup
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("favorites_tab_title", comment: "Favorites View Controller Title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()
    }
}