//
//  WeatherModel.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WeatherModel {
    var country = ""
    var condition = ""
    var temperature = ""
    var city = ""
    
    static func fromJSON(_ data: Any) -> WeatherModel {
        let json = JSON(data)
        let model = WeatherModel(country: json["sys"]["country"].stringValue,
                                 condition: json["weather"]["main"].stringValue,
                                 temperature: json["main"]["temp"].stringValue,
                                 city: json["name"].stringValue)
        return model
    }
}
