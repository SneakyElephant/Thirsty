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
        /*
        ParseManager.findNearestCity { (result: (city: City?, error: NSError!)) -> Void in
            if let city = result.city? {
                println("The first city is \(city.name)")
            } else if let error = result.error {
                println("Error: \(error.localizedDescription)")
            } else {
                println("City Not Found")
            }
        }
        
        ParseManager.findAllBars { (result: (bars: [Bar]?, error: NSError!)) -> Void in
            if let bars = result.bars? {
                for bar in bars {
                    println("Bar Found: \(bar.name)")
                }
            } else if let error = result.error {
                println("Error: \(error.localizedDescription)")
            } else {
                println("Bars Not Found")
            }
        } */
    }
    
    class func findNearestCity (completion: ((city: City?, error: NSError!)) -> Void) {
        let query = City.query()
        //TODO: Find the closest city not the first/only one in the DB.
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var result = (objects.first as? City, error)
            completion(result)
        }
    }
    
    class func findAllBars (completion: ((bars: [Bar]?, error: NSError!)) -> Void) {
        let query = Bar.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var result = (objects as? [Bar], error)
            completion(result)
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