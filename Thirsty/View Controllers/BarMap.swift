//
//  BarMap.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/29/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import UIKit

//MARK: Setup

class BarMapViewController: UIViewController {
    var locationManager: CLLocationManager?
    var mapView: MKMapView?
    var overlayView: MapOverlayView?
    var barDetailView: BarDetailView?
    let selectedBarKey = "SelectedBarKey"
    var skipBarZoomAnimation: Bool = false
    private var topOverlayViewConstraint: NSLayoutConstraint? = nil
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    override init(nibName pNibNameOrNil: String!, bundle pNibBundleOrNil: NSBundle!) {
        super.init(nibName: pNibNameOrNil, bundle: pNibBundleOrNil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("bar_tab_title", comment: "Bar View Controller Title")
        tabBarItem.image = UIImage(named: "BarTabIcon")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        
        mapView = MKMapView()
        mapView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView?.showsUserLocation = true
        mapView?.showsPointsOfInterest = false
        mapView?.rotateEnabled = false
        mapView?.delegate = self
        view.addSubview(mapView!)
        
        populateMap()
        
        overlayView = MapOverlayView(frame: view.bounds)
        overlayView?.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        barDetailView = BarDetailView()
        overlayView?.contentView = barDetailView!
        view.addSubview(overlayView!)
        
        hideContentViewIfNeeded(false)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += mapView!.layoutInside(view)
        view.addConstraints(constraints)
    }
}

//MARK: Map Updates

extension BarMapViewController {
    func populateMap () {
        ParseManager.findNearestCity { (result: (city: City?, error: NSError!)) -> Void in
            if let city = result.city? {
                //only zoom if we don't have a bar to zoom to
                var barID = NSUserDefaults.standardUserDefaults().objectForKey(self.selectedBarKey) as? String
                if barID == nil {
                    self.zoomToCity(city: city, animated: false)
                }
            } else if let error = result.error {
                println("Error: \(error.localizedDescription)")
            } else {
                println("City Not Found")
            }
        }
        
        ParseManager.findAllBars { (result: (bars: [Bar]?, error: NSError!)) -> Void in
            if let bars = result.bars? {
                self.updateBarAnnotations(bars: bars)
            } else if let error = result.error {
                println("Error: \(error.localizedDescription)")
            } else {
                println("Bars Not Found")
            }
        }
    }
    
    func zoomToCity (city pCity: City, animated pAnimated: Bool) {
        var span = MKCoordinateSpanMake(0.2, 0.2)
        var coordinateRegion = MKCoordinateRegionMake(pCity.coordinates, span)
        mapView?.setRegion(coordinateRegion, animated: pAnimated)
    }
    
    func updateBarAnnotations (bars pBars: [Bar]) {
        mapView?.removeAnnotations(mapView?.annotations)
        var barID = NSUserDefaults.standardUserDefaults().objectForKey(selectedBarKey) as? String
        let selectedBar = pBars.filter{ $0.objectId == barID }.first
        for bar: Bar in pBars {
            if bar.visible {
                var barAnnotation = BarAnnotation(bar: bar)
                mapView?.addAnnotation(barAnnotation)
                if bar == selectedBar {
                    mapView?.selectAnnotation(barAnnotation, animated: false)
                }
            }
        }
    }
    
    func zoomToBarAnnotationView (annotationView pAnnotationView: BarAnnotationView) {
        zoomToBar(bar: pAnnotationView.bar!)
    }
    
    func zoomToBar (bar pBar: Bar) {
        if (self.mapView?.region.span.latitudeDelta > 0.004) {
            let region = MKCoordinateRegion(center: pBar.coordinates, span: MKCoordinateSpanMake(0.001, 0.001))
            mapView?.setRegion(region, animated: !skipBarZoomAnimation)
        } else {
            mapView?.setCenterCoordinate(pBar.coordinates, animated: !skipBarZoomAnimation)
        }
        
        skipBarZoomAnimation = false
        
        barDetailView!.bar = pBar
        self.setContentViewHidden(false, animated: true)
    }
    
    func hideContentViewIfNeeded(animated: Bool) {
        //only zoom if we don't have a bar to zoom to
        var barID = NSUserDefaults.standardUserDefaults().objectForKey(self.selectedBarKey) as? String
        if barID == nil {
            self.setContentViewHidden(true, animated: animated)
        }
    }
    
    func setContentViewHidden(hidden: Bool, animated: Bool) {
        var duration = 0.0
        if animated {
            duration = 0.3
        }
        var cellHeight = BarDetailView.topCellHeight
        if !hidden {
            cellHeight = 0
        }
        UIView.animateWithDuration(duration, animations: { () in
            self.overlayView?.frame = CGRectMake(0, CGFloat(cellHeight), self.view.bounds.width, self.view.bounds.height)
            return
        })
    }
}

//MARK: Map View Delegate

extension BarMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation pAnnotation: MKAnnotation!) -> MKAnnotationView! {
        if pAnnotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? BarAnnotationView
        if annotationView == nil {
            if let barAnnotation: BarAnnotation = pAnnotation as? BarAnnotation{
                annotationView = BarAnnotationView(bar: barAnnotation.bar)
            }
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if view.annotation is MKUserLocation {
            return
        }
        
        if let annotationView = view as? BarAnnotationView {
            annotationView.selected = true
            zoomToBarAnnotationView(annotationView: annotationView)
            NSUserDefaults.standardUserDefaults().setObject(annotationView.bar?.objectId, forKey: selectedBarKey)
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        if view.annotation is MKUserLocation {
            return
        }
        
        if let annotationView = view as? BarAnnotationView {
            annotationView.selected = false
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: selectedBarKey)
            hideContentViewIfNeeded(true)
        }
    }
}

//MARK: Map Helper Views

class BarAnnotation: NSObject, MKAnnotation {
    var bar: Bar
    var coordinate: CLLocationCoordinate2D {
        get {
            return bar.coordinates
        }
    }
    
    init(bar pBar: Bar) {
        bar = pBar
        super.init()
    }
}

class BarAnnotationView: MKAnnotationView {
    var bar: Bar? = nil
    let imageView = UIImageView()
    override var selected: Bool {
        willSet (newSelected) {
            if newSelected {
                imageView.image = UIImage(named: "MapPointer")
                imageView.contentMode = UIViewContentMode.Bottom
            } else {
                imageView.image = UIImage(named: "MapDot")
                imageView.contentMode = .Center
            }
        }
    }
    
    convenience init(bar pBar: Bar) {
        self.init(frame: CGRectZero)
        bar = pBar
        
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.image = UIImage(named: "MapDot")
        imageView.contentMode = .Center
        addSubview(imageView)
        
        self.addConstraints(imageView.layoutInside(self))
    }
    
    override init(frame: CGRect) {
        let annotationHeight: CGFloat = 14.0 //arbitraty size. update when we have the real asset
        let annotationWidth: CGFloat = 20.0
        super.init(frame: CGRectMake(0, 0, annotationWidth, annotationHeight))
    }
    
    //This initializer is "required" but should never be used.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}