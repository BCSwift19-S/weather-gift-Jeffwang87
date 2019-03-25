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

class WeatherDetail: WeatherLocation {
    struct HourlyForecast {
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
    }
    
  
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var hourlyForecastArray = [HourlyForecast]()
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIkey + coordinates
        print(weatherURL)
        Alamofire.request(weatherURL).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let temperature = json["currently"]["temperature"].double{
                        let roundedTemp = String(format: "%3.f", temperature)
                        self.currentTemp = roundedTemp + "°"
                        print("*** Current Temp = \(roundedTemp)")
                        
                    }
                    if let summary = json["currently"]["summary"].string {
                       self.currentSummary = summary
                    }
                    if let icon = json["currently"]["icon"].string {
                        self.currentIcon = icon
                    }
                    if let timeZone = json["timezone"].string {
                        self.timeZone = timeZone
                    }
                    if let time = json["currently"]["time"].double {
                        self.currentTime = time
                    }
                    let dailyDataArray = json["daily"]["data"]
                    self.dailyForecastArray = []
                    let days = min(7, dailyDataArray.count-1)
                    for day in 1...days {
                        let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                        let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                        let dateValue = json["daily"]["data"][day]["time"].doubleValue
                        let icon = json["daily"]["data"][day]["icon"].stringValue
                        let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                        let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                        self.dailyForecastArray.append(newDailyForecast)
                    }
                    
                        let hourlyDataArray = json["hourly"]["data"]
                        self.hourlyForecastArray = []
                    let hours = min(24, hourlyDataArray.count-1)
                    for hour in 1...hours{
                        let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                        let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                        let hourlyPreciprob = json["hourly"]["data"][hour]["precipProbability"].doubleValue
                        let hourlyIcon = json["hourly"]["data"][hour]["icon"].stringValue
                        let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPreciprob, hourlyIcon: hourlyIcon)
                        self.hourlyForecastArray.append(newHourlyForecast)
                    }
                    
                    case .failure(let error):
                    print(error)
                }
                completed()
            }
        }
    }
