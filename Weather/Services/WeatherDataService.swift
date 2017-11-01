//
//  WeatherDataService.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import Moya
import CoreLocation.CLLocation

fileprivate struct NetworkConstants {
    static let weatherApiKey = "0b3b4d68a84287227d33e170bfccea1b"
    
}

public enum WeatherData {
    case loadPlace(CLLocationDegrees, CLLocationDegrees)
}

extension WeatherData: TargetType {
    public var sampleData: Data {
        return Data() // HACK: -
    }
    
    public var headers: [String : String]? {
        return [:]
    }
 
    public var baseURL: URL { return URL(string: "https://api.openweathermap.org/data/2.5")! }
    
    public var path: String {
        switch self {
        case .loadPlace:
            return "/weather"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .loadPlace(let lat, let lon):
            let parameters = ["lat": lat, "lon": lon, "APPID": "0b3b4d68a84287227d33e170bfccea1b"] as [String : Any]
            return .requestParameters(parameters:parameters, encoding: URLEncoding.default)
        }
    }
}
