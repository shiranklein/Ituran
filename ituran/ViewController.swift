//
//  ViewController.swift
//  ituran
//
//  Created by אביעד on 09/03/2021.
//  Copyright © 2021 Shiran Rahamim. All rights reserved.
//



//*****************************


//import UIKit
//import CoreLocation
//class ViewController: UIViewController, CLLocationManagerDelegate {
//
//    var locationManager:CLLocationManager!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        determineMyCurrentLocation()
//    }
//
//
//    func determineMyCurrentLocation() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            //locationManager.startUpdatingHeading()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        // Call stopUpdatingLocation() to stop listening for location updates,
//        // other wise this function will be called every time when user location changes.
//
//       // manager.stopUpdatingLocation()
//
//
//
//print("shiran")
//        print("user latitude = \(userLocation.coordinate.latitude)")
//        print("user longitude = \(userLocation.coordinate.longitude)")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        print("Error \(error)")
//    }
//}

//************* see user location on map *****************

//import UIKit
//import MapKit
//
//class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
//
//
//    @IBOutlet weak var mapView: MKMapView!
//    let locationManager = CLLocationManager()
//
//    override func viewDidLoad() {
//    super.viewDidLoad()
//
//    self.locationManager.requestAlwaysAuthorization()
//    self.locationManager.requestWhenInUseAuthorization()
//
//    if CLLocationManager.locationServicesEnabled() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//    mapView.delegate = self
//    mapView.mapType = .standard
//    mapView.isZoomEnabled = true
//    mapView.isScrollEnabled = true
//
//    if let coor = mapView.userLocation.location?.coordinate{
//        mapView.setCenter(coor, animated: true)
//    }
//
//}
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations
//        locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        mapView.mapType = MKMapType.standard
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        annotation.title = "You are Here"
//        mapView.addAnnotation(annotation)
//    }
//}

//*************** see user cordination ***************

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLongi: UILabel!
    @IBOutlet weak var labelAdd: UILabel!

    
    var locationManager:CLLocationManager!
    
    
       override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
       locationManager.delegate = self
      //  locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.requestAlwaysAuthorization()
        
      
        //בדיקה-הוספה עבור התראות..........
//        UIApplication.shared.cancelAllLocalNotifications()
//  //סוף בדיקה............
      
        if CLLocationManager.locationServicesEnabled(){
           locationManager.startUpdatingLocation()
       }
        
        
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        self.labelLat.text = "\(userLocation.coordinate.latitude)"
        self.labelLongi.text = "\(userLocation.coordinate.longitude)"

//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
        
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//
//                self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//        }
//      }
        

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
 
//    ********* move to maps app on iphone ***********
    
    @IBAction func openMap(_ sender: Any) {
    
        let locationManager = CLLocationManager()
        var currentLoc: CLLocation!
        currentLoc = locationManager.location

        
        let latitude = currentLoc.coordinate.latitude
        let longitude = currentLoc.coordinate.longitude

        let appleURL = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?ll=\(latitude),\(longitude)"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"

        let googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]

        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }

        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }

        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    //*************** notification when app close ***************
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorized status changed")
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            let circularRegion = CLCircularRegion.init(center: CLLocationCoordinate2DMake(32.03046, 34.79795),
                                                       radius: 100.0,
                                                       identifier: "ituran")
            circularRegion.notifyOnEntry = true
            circularRegion.notifyOnExit = false
            locationManager.startMonitoring(for: circularRegion)
           
        }
    }
    
    func fireNotification(notificationText: String, didEnter: Bool) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = "ituran notification"
                content.body = notificationText
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
                
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        // Handle the error
                    }
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did Arrive: \(region.identifier)")
        fireNotification(notificationText: "\(region.identifier)", didEnter: true)
    }

}
