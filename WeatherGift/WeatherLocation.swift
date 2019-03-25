//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by wxt on 3/25/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import Foundation

class WeatherLocation: Codable{
    var name = ""
    var coordinates = ""
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
    
}
