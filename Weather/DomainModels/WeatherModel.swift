//
//  WeatherModel.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

struct WeatherModel: Codable {
    var country = ""
    var condition = ""
    var temperature = ""
    var city = ""
    var lan: Double = 0
    var lon: Double = 0
    
    static func fromJSON(_ data: Any, coordinate: CLLocationCoordinate2D) -> WeatherModel {
        let json = JSON(data)
        let model = WeatherModel(country: json["sys"]["country"].stringValue,
                                 condition: json["weather"]["main"].stringValue,
                                 temperature: json["main"]["temp"].stringValue,
                                 city: json["name"].stringValue,
                                 lan: coordinate.latitude,
                                 lon: coordinate.longitude)
        return model
    }
}
