//
//  ParseManager.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/29/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import Foundation

class ParseManager {
    class func setup() {
        Parse.setApplicationId("5FiNXikvo1bjHfZ3fFCgy2afeT3LsxbI1bnNzpX8", clientKey: "kk7cA8ZRtD7BQc1mdRfImReVAX358iOEqVcJUxRH")
    }
    
    class func findNearestCity (completion pCompletion: ((city: City?, error: NSError!)) -> Void) {
        let query = City.query()
        //TODO: Find the closest city not the first/only one in the DB.
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var result = (objects.first as? City, error)
            pCompletion(result)
        }
    }
    
    class func findAllBars (completion pCompletion: ((bars: [Bar]?, error: NSError!)) -> Void) {
        let query = Bar.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var result = (objects as? [Bar], error)
            pCompletion(result)
        }
    }
    
    class func findAllVisibleBars (completion pCompletion: ((bars: [Bar]?, error: NSError!)) -> Void) {
        let query = Bar.query()
        query.whereKey("visible", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var result = (objects as? [Bar], error)
            pCompletion(result)
        }
    }
}

class City: PFObject, PFSubclassing {
    @NSManaged var name: String
    @NSManaged var location: PFGeoPoint
    var coordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(location.latitude, location.longitude)
        }
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String! {
        return "City"
    }
}

class Bar: PFObject, PFSubclassing {
    @NSManaged var name: String
    @NSManaged var address: String
    @NSManaged var about: String
    @NSManaged var location: PFGeoPoint
    @NSManaged var website: String
    @NSManaged var visible: Bool
    @NSManaged var city: City
    var favorited: Bool {
        get {
            return true;
        }
    }
    var coordinates: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(location.latitude, location.longitude)
        }
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String! {
        return "Bar"
    }
}