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
    
    required init(coder pDecoder: NSCoder) {
        super.init(coder: pDecoder)
    }
    
    override init(nibName pNibNameOrNil: String!, bundle pNibBundleOrNil: NSBundle!) {
        super.init(nibName: pNibNameOrNil, bundle: pNibBundleOrNil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("bar_tab_title", comment: "Bar View Controller Title")
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
        overlayView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        barDetailView = BarDetailView()
        overlayView?.contentView = barDetailView!
        view.addSubview(overlayView!)
        
        var constraints: [NSLayoutConstraint] = []
        constraints += mapView!.layoutInside(view)
        constraints += overlayView!.layoutInside(view)
        view.addConstraints(constraints)
    }
}

//MARK: Map Updates

extension BarMapViewController {
    func populateMap () {
        ParseManager.findNearestCity { (result: (city: City?, error: NSError!)) -> Void in
            if let city = result.city? {
                self.zoomToCity(city: city, animated: false)
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
        for bar: Bar in pBars {
            if bar.visible {
                var barAnnotation = BarAnnotation(bar: bar)
                mapView?.addAnnotation(barAnnotation)
            }
        }
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
    private let cornerRadius: CGFloat = 7
    
    convenience init(bar pBar: Bar) {
        self.init(frame: CGRectZero)
        bar = pBar
        
        //TODO: Style this and switch it to an image.
        self.layer.cornerRadius = cornerRadius
        backgroundColor = UIColor.purpleColor()
    }
    
    override init(frame: CGRect) {
        let annotationSize: CGFloat = 15.0
        super.init(frame: CGRectMake(0, 0, annotationSize, annotationSize))
    }
    
    //This initializer is "required" but should never be used.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}