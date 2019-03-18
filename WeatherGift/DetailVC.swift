//
//  DetailVC.swift
//  WeatherGift
//
//  Created by wxt on 2/27/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit
import CoreLocation
class DetailVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManger: CLLocationManager!
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPage != 0 {
            self.locationsArray[0].getWeather {
                self.updateUserInterface()
            }           
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }
    func updateUserInterface() {
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        tempLabel.text = locationsArray[currentPage].currentTemp
        summaryLabel.text = locationsArray[currentPage].currentSummary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
    }
}

extension DetailVC: CLLocationManagerDelegate {
    func getLocation(){
        locationManger = CLLocationManager()
        locationManger.delegate = self
        
    }
    
    func handleLocationAuthozizationStatus(Status: CLAuthorizationStatus){
        switch Status {
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManger.requestLocation()
        case .denied:
            print("I'm sorry - can't show location")
        case .restricted:
            print("Acess denied")
        }
}
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthozizationStatus(Status: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentlongtitude = currentLocation.coordinate.longitude
        let currentCoordinates = "\(currentLatitude), \(currentlongtitude)"
        dateLabel.text = currentCoordinates
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
            {placemarks, error in
            if placemarks != nil {
                let placemarks = placemarks?.last
                place = (placemarks?.name)!
            } else {
                print("Error retrieving place. Error Code: \(error!)")
                place = "Unknown Weather Location"
                }
          self.locationsArray[0].name = place
          self.locationsArray[0].coordinates = currentCoordinates
                self.locationsArray[0].getWeather {
          self.updateUserInterface()
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
}
