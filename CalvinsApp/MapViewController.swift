//
//  ViewController.swift
//  CalvinsApp
//
//  Created by Jizi Zhang on 2016-09-01.
//  Copyright © 2016 Jizi Zhang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var artworks =  [Artwork]()
    
    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(artworks)
        
        let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park",
                              discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
        
        
        /*enable the following to use current location
         super.viewDidLoad()
         self.locationManager.delegate = self
         self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
         self.locationManager.requestWhenInUseAuthorization()
         self.locationManager.startUpdatingLocation()
         self.mapView.showsUserLocation = true
         */
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadInitialData() {
        // 1
        let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json");
        //    var readError : NSError?
        var data: NSData?
        do {
            data = try NSData(contentsOfFile: fileName!, options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // 2
        //    var error: NSError?
        var jsonObject: AnyObject? = nil
        if let data = data {
            do {
                _ = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject],
            // 4
            let jsonData = JSONValue.fromObject(object: jsonObject as AnyObject)?["data"]?.array {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    // 5
                    let artwork = Artwork.fromJSON(json: artworkJSON) {
                    artworks.append(artwork)
                }
            }
        }
    }
    
    
    
    
    //Location Delegate Methods
    /*
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
     let location = locations.last
     let centre = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
     let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
     self.mapView.setRegion(region, animated: true)
     self.locationManager.startUpdatingLocation()
     self.locationManager.stopUpdatingLocation()
     
     //drop a pin at user's current location
     mapView?.removeAnnotations(mapView.annotations)
     let myAnnotation: MKPointAnnotation = MKPointAnnotation()
     myAnnotation.coordinate = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
     myAnnotation.title = "You're Here"
     mapView.addAnnotation(myAnnotation)
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print("Errors" + error.localizedDescription)
     }
     */
    
    
    
    
}
