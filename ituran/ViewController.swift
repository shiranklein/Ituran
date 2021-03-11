//
//  ViewController.swift
//  ituran
//
//  Created by אביעד on 09/03/2021.
//  Copyright © 2021 Shiran Rahamim. All rights reserved.
//


import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLongi: UILabel!
    
    var locationManager:CLLocationManager!
    
    let ituranLat = 32.03046
    let ituranLongi = 34.79795
    let regionRadius = 100.0
    let welcomeText = "ברוך הבא לאיתוראן!"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //MARK: - location delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        self.labelLat.text = "\(userLocation.coordinate.latitude)"
        self.labelLongi.text = "\(userLocation.coordinate.longitude)"
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
        
        let installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
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
    
    
    //*************** set the region ***************
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorized status changed")
        let ituranCoordinate = CLLocationCoordinate2DMake(self.ituranLat,self.ituranLongi)
        let regionRadius = self.regionRadius
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            let circularRegion = CLCircularRegion.init(center: ituranCoordinate,
                                                       radius: regionRadius, identifier: "ituran")
            circularRegion.notifyOnEntry = true
            circularRegion.notifyOnExit = false
            locationManager.startMonitoring(for: circularRegion)
        }
        userLocationIsInRegionWhenAppOpened()
    }
    
    //********** if user enter the region => fire the notification/popup ************
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if UIApplication.shared.applicationState == .active {
            firePopup(notificationText: self.welcomeText, didEnter: true)
        } else {
            fireNotification(notificationText: self.welcomeText, didEnter: true)
        }
    }
    
    
    // *********** notification when the app is closed ***************
    func fireNotification(notificationText: String, didEnter: Bool) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = notificationText
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                    }
                })
            }
        }
    }
    
    // ************** popup when the app is open ****************
    func firePopup(notificationText: String, didEnter: Bool) {
        let alert = UIAlertController(title: notificationText, message:"", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    
    // ******* handle a scenario where the phone's location is already inside a region when app opend *******
    func userLocationIsInRegionWhenAppOpened(){
        var userLoc: CLLocation!
        userLoc = locationManager.location
        let userlocCoor = CLLocation(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
        let ituranCoordinate = CLLocation(latitude: self.ituranLat, longitude: self.ituranLongi)
        let regionRadius = self.regionRadius
        let distanceInMeters = userlocCoor.distance(from: ituranCoordinate)
        print("\(distanceInMeters)")
        
        if distanceInMeters <= regionRadius {
            firePopup(notificationText: self.welcomeText, didEnter: true)
            print("in the region")
        } else {
            print("not in the region")
        }
    }
    
}
