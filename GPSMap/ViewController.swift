//
//  ViewController.swift
//  GPSMap
//
//  Created by Austin Han on 2017-01-17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.tintColor = UIColor(red: 0.298, green: 0.851, blue: 0.392, alpha: 0.9)
        self.mapView.showsCompass = true;
        
        //self.mapView.showsBuildings = true;

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingHeading()
        mapView.showsUserLocation = true
        
        mapView.camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D.init(latitude: 0, longitude: 0), fromDistance: CLLocationDistance(450) , pitch: 50.0, heading: (0));


        
//        let userCoordinate = CLLocationCoordinate2D(latitude: 58.592725, longitude: 16.185962)
//        let eyeCoordinate = CLLocationCoordinate2D(latitude: 58.571647, longitude: 16.234660)
//        let mapCamera = MKMapCamera(lookingAtCenterCoordinate: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400.0)
//        
//        //Setup our Map View
//        mapView.delegate = self
//        mapView.mapType = MKMapType.Standard
//        mapView.setCamera(mapCamera, animated: true)
     /*   var mapCam = MKMapCamera(lookingAtCenter: mapView.userLocation.coordinate, fromEyeCoordinate: mapView.userLocation.coordinate, eyeAltitude: CLLocationDistance(300) )
        mapView.setCamera(mapCam, animated: true) */
        
        
//        let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
//        
//        // 3.
//        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
//        
//        // 4.
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//        
//        // 5.
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "Times Square"
//        
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//        
//        
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "Empire State Building"
//        
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//        
//        // 6.
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//        
//        // 7.
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .Automobile
//        
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//        
//        // 8.
//        directions.calculateDirectionsWithCompletionHandler {
//            (response, error) -> Void in
//            
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                
//                return
//            }
//            
//            let route = response.routes[0]
//            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
//            
////            let rect = route.polyline.boundingMapRect
////            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//        }
//        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.lightGray
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let auth = CLLocationManager.authorizationStatus()
        if (auth == .authorizedAlways || auth == .authorizedWhenInUse){
            mapView.showsUserLocation = true
            let mapCam:MKMapCamera = mapView.camera.copy() as! MKMapCamera;
            if let hd = userLocation.heading{
                print("Heading Change")
                mapCam.heading = (hd.magneticHeading)
                
            }
            else{
                mapCam.centerCoordinate = userLocation.coordinate
                print("hello")
            }
            mapCam.centerCoordinate = userLocation.coordinate
            mapView.setCamera(mapCam, animated: false)
            // centerMapOnLocation(location: userLocation.location!, regionRadius: 500)
        }
        
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("Heading Changed2")
        let mapCam = MKMapCamera(lookingAtCenter: mapView.userLocation.coordinate, fromDistance: CLLocationDistance(450) , pitch: 50, heading: (newHeading.magneticHeading));
        mapView.setCamera(mapCam, animated: false)
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did Update Location");
    }

    func findUserLoc(){
        let auth = CLLocationManager.authorizationStatus()
        
        if (auth == .notDetermined){
            locationManager.requestAlwaysAuthorization()
            
        }
        else if (auth == .denied || auth == .restricted){
            let alertController = UIAlertController(title: "Location Service", message: "Location Service Turned Off. Cannot Detect Local AEDs and First Aiders", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            print("Auth denied called")
        }
        else{
            //print("showing location")
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            //print(mapView.userLocationVisible)
            
        }
    }
    
    // MARK: locationManager delegate
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        findUserLoc()
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        // print(location.coordinate)
     //   let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
          //                                                        regionRadius * 2.0, regionRadius * 2.0)
        //mapView.setRegion(coordinateRegion, animated: true)
    
        
    }
    
    
    
    


}

