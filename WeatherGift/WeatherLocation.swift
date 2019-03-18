//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by wxt on 3/16/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIkey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let temperature = json["currently"]["temperature"].double{
                        let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                    }
                    if let summary = json["daily"]["summary"].string {
                       self.currentSummary = summary
                    }
                    if let icon = json["daily"]["summary"].string {
                        self.currentIcon = icon
                    }
                case .failure(let error):
                    print(error)
                }
                completed()
            }
        }
    }
