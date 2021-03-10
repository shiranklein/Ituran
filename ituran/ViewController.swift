//
//  ViewController.swift
//  ituran
//
//  Created by אביעד on 09/03/2021.
//  Copyright © 2021 Shiran Rahamim. All rights reserved.
//


//*************** see user cordination ***************

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLongi: UILabel!

    var locationManager:CLLocationManager!
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
       locationManager.delegate = self
      //  locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.requestAlwaysAuthorization()
        
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
        
        // optipns for more navigations apps:
//        let googleURL = "comgooglemaps://?ll=\(latitude),\(longitude)"
//        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
//
//        let googleItem = ("Google Map", URL(string:googleURL)!)
//        let wazeItem = ("Waze", URL(string:wazeURL)!)
        
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]

//        if UIApplication.shared.canOpenURL(googleItem.1) {
//            installedNavigationApps.append(googleItem)
//            print("mami2")
//        }
//
//        if UIApplication.shared.canOpenURL(wazeItem.1) {
//            installedNavigationApps.append(wazeItem)
//            print("mami")
//        }

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
    
    
    //*************** notification ***************
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorized status changed")
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            let circularRegion = CLCircularRegion.init(center: CLLocationCoordinate2DMake(32.03046, 34.79795),
                                                       radius: 100.0, identifier: "ברוך הבא לאיתוראן!")
            circularRegion.notifyOnEntry = true
            circularRegion.notifyOnExit = false
            locationManager.startMonitoring(for: circularRegion)
           
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if UIApplication.shared.applicationState == .active {
        print("Did Arrive2: \(region.identifier)")
        firePopup(notificationText: "\(region.identifier)", didEnter: true)
        } else {
        print("Did Arrive: \(region.identifier)")
         fireNotification(notificationText: "\(region.identifier)", didEnter: true)
        }
    }
    
//    func startMySignificantLocationChanges() {
//        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
//            // The device does not support this service.
//            return
//        }
//        locationManager.startMonitoringSignificantLocationChanges()
//    }
    
    // *********** when the app is closed ***************
    func fireNotification(notificationText: String, didEnter: Bool) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = notificationText
                //content.body = notificationText
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
    
    // ************** when the app is open ****************
    
    func firePopup(notificationText: String, didEnter: Bool) {
        let alert = UIAlertController(title: notificationText, message:"", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alert.addAction(cancel)
               present(alert, animated: true)
     
        
    }

}
