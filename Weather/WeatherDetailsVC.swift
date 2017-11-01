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
    var location: CLLocationCoordinate2D
    var model: WeatherModel?
    
    
    init(location: CLLocationCoordinate2D) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.white
        
        SVProgressHUD.show()
        provider.request(.loadPlace(location.latitude, location.longitude), completion: { (result) in
            SVProgressHUD.dismiss()
            
            if case let .success(response) = result {
                
                do {
                    let message = try response.mapJSON()
                    self.model = WeatherModel.fromJSON(message)
                    DispatchQueue.main.async {
                        self.setupView()
                    }
                } catch {
                    print("Wrong Json")
                }
            }
        })
    }
    
    func setupView() {
        form
            +++ Section("Weather details")
            
            <<< LabelRow("country"){ [unowned self] row in
                row.title = "Country"
                row.value = self.model?.country
            }
            
            <<< LabelRow("condition"){ [unowned self] row in
                row.title = "Condition"
                row.value = self.model?.condition
            }
            
            <<< LabelRow("temperature"){ [unowned self] row in
                row.title = "Temperature"
                row.value = self.model?.temperature
            }
            
            <<< LabelRow("city"){ [unowned self] row in
                row.title = "City"
                row.value = self.model?.city
        }
    }
}

