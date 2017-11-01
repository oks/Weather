//
//  StorageService.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class StorageService {
    
    private static var objects: [WeatherModel] = []
    
    static func loadData() -> [WeatherModel] {
            let data = Defaults[.models]
            let jsonDecoder = JSONDecoder()
        do {
            let models = try jsonDecoder.decode(Array<WeatherModel>.self, from: data)
            objects = models
            return models
        } catch {
            print("Dencoding Errors")
        }
        
        return []
    }
 
    static func addModel(_ model: WeatherModel) {
        objects.append(model)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(objects)
            Defaults[.models] = jsonData
        }
        catch {
            print("Encoding Errors")
        }
    }
}


extension DefaultsKeys {
    static let models = DefaultsKey<Data>("models")
}
