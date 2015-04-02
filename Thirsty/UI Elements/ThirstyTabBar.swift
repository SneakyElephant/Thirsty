//
//  ThirstyTabBar.swift
//  ThirstyTabBar
//
//  Created by Stephen Thomas on 4/1/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import UIKit

class ThirstyTabBarController: UIViewController {
    let tabBar = ThirstyTabBar()
    let contentContainer = UIView()
    let tabBarHeight = 60
    let tabBarBackgroundColor =  UIColor.buttonColor()
    private var forceLoad = true //Used to indicate the view controllers array has been changed so the first view is loaded even if 0 was the previously selected index.
    var viewControllers: [UIViewController] = [] {
        didSet {
            updateViewControllers(oldValue)
        }
    }
    var selectedIndex: Int = 0 {
        willSet {
            if (newValue != selectedIndex && newValue < viewControllers.count) || forceLoad { //If we have a new, valid value or are forced to load...
                //add new view controller as a child and place view
                let selectedViewController = viewControllers[newValue]
                addChildViewController(selectedViewController)
                contentContainer.addSubview(selectedViewController.view)
                selectedViewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
                selectedViewController.didMoveToParentViewController(self)
                
                var constraints: [NSLayoutConstraint] = []
                constraints += selectedViewController.view.layoutInside(contentContainer)
                contentContainer.addConstraints(constraints)
            }
        }
        didSet {
            if oldValue != selectedIndex {
                //remove old
                let oldViewController = viewControllers[oldValue]
                oldViewController.willMoveToParentViewController(nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
            }
            forceLoad = false
        }
    }
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    override init(nibName pNibNameOrNil: String!, bundle pNibBundleOrNil: NSBundle!) {
        super.init(nibName: pNibNameOrNil, bundle: pNibBundleOrNil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(contentContainer)
        
        tabBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabBar.backgroundColor = tabBarBackgroundColor
        tabBar.dividerColor = UIColor.backgroundColor()
        tabBar.selectedColor = UIColor.selectedColor()
        tabBar.addTarget(self, action: "tabSelected", forControlEvents: .ValueChanged)
        view.addSubview(tabBar)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += contentContainer.layoutRelativeTo(view, insets: Inset(0, from: .Top), Inset(0, from: .Left), Inset(0, from: .Right), Inset(CGFloat(tabBarHeight), from: .Bottom))
        constraints += tabBar.layoutBelow(contentContainer, distance: 0)
        constraints += tabBar.layoutRelativeTo(view, insets: Inset(0, from: .Left), Inset(0, from: .Right), Inset(0, from: .Bottom))
        view.addConstraints(constraints)
        
        updateViewControllers(nil)
    }
    
    @objc func tabSelected() {
        selectedIndex = tabBar.selectedIndex
    }
    
    func updateViewControllers(oldViewControllers: [UIViewController]?) {
        //remove old view controller if needed
        if  let oldViewControllers = oldViewControllers? {
            if selectedIndex < oldViewControllers.count {
                let oldViewController = oldViewControllers[selectedIndex]
                oldViewController.willMoveToParentViewController(nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
            }
        }
        
        //create tab items and populate tab bar
        var tabBarItems: [ThirstyTabBarItem] = []
        for index in 0..<viewControllers.count {
            let viewController = viewControllers[index]
            let tabBarItem = ThirstyTabBarItem(title: viewController.title, image: viewController.tabBarItem.image, index: index)
            tabBarItems.append(tabBarItem)
        }
        forceLoad = true
        tabBar.tabBarItems = tabBarItems //this will call back and set our selected index to 0
    }
}

class ThirstyTabBar: UIControl {
    private var tabBarButtons: [ThirstyTabBarButton] = []
    private var dividers: [UIView] = []
    private var currentIndex = 0 //this property is hidden so that it can be set when a button is tapped without created in infinite loop.
    var dividerColor = UIColor.blackColor()
    var selectedColor = UIColor.blueColor()
    var selectedIndex: Int {
        get {
            return currentIndex
        }
        set {
            if newValue < tabBarButtons.count {
                tabBarButtonSelected(tabBarButtons[newValue])
            }
        }
    }
    var tabBarItems: [ThirstyTabBarItem] = [] {
        willSet {
            //reset
            for oldButton in tabBarButtons {
                oldButton.removeFromSuperview()
            }
            for divider in dividers {
                divider.removeFromSuperview()
            }
            tabBarButtons = []
            dividers = []
            
            var previousButton: ThirstyTabBarButton? = nil
            var constraints: [NSLayoutConstraint] = []
            
            for tabBarItem in newValue {
                //create a new button
                let newButton = ThirstyTabBarButton()
                newButton.label.text = tabBarItem.title
                newButton.imageView.image = tabBarItem.image
                newButton.index = tabBarItem.index
                newButton.addTarget(self, action: "tabBarButtonSelected:", forControlEvents: .TouchUpInside)
                addSubview(newButton)
                tabBarButtons.append(newButton)
                
                if let previousButton = previousButton? { //items after the first one
                    //create a divider
                    let dividerPadding = 7
                    let dividerWidth = 1
                    let divider = UIView()
                    divider.backgroundColor = dividerColor
                    divider.setTranslatesAutoresizingMaskIntoConstraints(false)
                    dividers.append(divider)
                    addSubview(divider)
                    
                    if find(newValue, tabBarItem) == newValue.count - 1 { //last item
                        constraints += newButton.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Bottom), Inset(0, from: .Right))
                    } else { //middle items
                        constraints += newButton.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Bottom))
                    }
                    constraints += divider.layoutAfter(previousButton, distance: 0)
                    constraints += divider.layoutRelativeTo(self, insets: Inset(CGFloat(dividerPadding), from: .Top), Inset(CGFloat(dividerPadding), from: .Bottom))
                    constraints += divider.constrainWidth(.Equal, toWidth: CGFloat(dividerWidth))
                    constraints += newButton.layoutAfter(divider, distance: 0)
                    constraints += newButton.constrainWidth(.Equal, toView: previousButton, plus: 0)
                } else { //first item
                    constraints += newButton.layoutRelativeTo(self, insets: Inset(0, from: .Top), Inset(0, from: .Bottom), Inset(0, from: .Left))
                }
                previousButton = newButton
            }
            
            addConstraints(constraints)
            
            self.selectedIndex = 0
        }
    }
    
    @objc private func tabBarButtonSelected (button: ThirstyTabBarButton) {
        //reset
        for button in tabBarButtons {
            button.backgroundColor = UIColor.clearColor()
        }
        for divider in dividers {
            divider.alpha = 1
        }
        
        //select button
        button.backgroundColor = selectedColor
        
        //hide dividers
        currentIndex = find(tabBarButtons, button)!
        if currentIndex < dividers.count {
            let rightDivider = dividers[currentIndex]
            rightDivider.alpha = 0
        }
        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            let leftDivider = dividers[previousIndex]
            leftDivider.alpha = 0
        }
        
        //notify
        sendActionsForControlEvents(.ValueChanged)
    }
}

private class ThirstyTabBarButton: UIControl {
    let label = UILabel() //This us unused but may be added in the future
    let imageView = UIImageView()
    var index = 0
    
    //TODO: Style this correctly
    
    override init() {
        super.init()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let gapBetweenImageAndLabel = 7
        
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .Center
        addSubview(imageView)
        
        self.backgroundColor = UIColor.clearColor()
        
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

class ThirstyTabBarItem: Equatable {
    var title: NSString? = "" //This us unused but may be added in the future
    var image: UIImage? = nil
    var index: Int = 0
    
    init (title: NSString?, image: UIImage?, index: Int) {
        self.title = title;
        self.image = image
        self.index = index
    }
}

func ==(lhs: ThirstyTabBarItem, rhs: ThirstyTabBarItem) -> Bool {
    return lhs.index == rhs.index
}

private func ==(lhs: ThirstyTabBarButton, rhs: ThirstyTabBarButton) -> Bool {
    return lhs.index == rhs.index
}