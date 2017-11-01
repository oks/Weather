//
//  WeatherDetails.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import MapKit
import Moya
import SVProgressHUD

class WeatherDetailsVC: FormViewController {
    
    let provider = MoyaProvider<WeatherData>()
    var location: CLLocationCoordinate2D?
    var model: WeatherModel?
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    init(model: WeatherModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather forecast"
        tableView.backgroundColor = UIColor.white
        
        if let weatherModel = model {
            setupView(model: weatherModel)
        } else {
            loadWeather()
        }
    }
    
    func loadWeather() {
        
        guard let coordinate = location else { return }
        
        SVProgressHUD.show()
        provider.request(.loadPlace(coordinate.latitude, coordinate.longitude),
                         completion: { [unowned self] (result) in
                            SVProgressHUD.dismiss()
                            
                            if case let .success(response) = result {
                                
                                do {
                                    let message = try response.mapJSON()
                                    let model = WeatherModel.fromJSON(message, coordinate: coordinate)
                                    StorageService.addModel(model)
                                    DispatchQueue.main.async {
                                        self.setupView(model: model)
                                    }
                                } catch {
                                    print("💀 - Wrong Json")
                                }
                            }
        })
    }
    
    func setupView(model: WeatherModel) {
        form
            +++ Section("Weather details")
             
            <<< LabelRow("country"){ row in
                row.title = "Country"
                row.value = model.country
            }
            
            <<< LabelRow("condition"){ row in
                row.title = "Condition"
                row.value = model.condition
            }
            
            <<< LabelRow("temperature"){ row in
                row.title = "Temperature"
                row.value = model.temperature
            }
            
            <<< LabelRow("city"){ row in
                row.title = "City"
                row.value = model.city
        }
    }
}

