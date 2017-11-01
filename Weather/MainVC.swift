//
//  MainVC.swift
//  Weather
//
//  Created by Oksana Kovalchuk on 11/1/17.
//  Copyright © 2017 ANODA. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MapKit

class MainVC: UIViewController {
    
    let mapView = MKMapView()
    let locationService = LocationService()
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
     
        // HACK: -
        _ = StorageService.loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Offline",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(presentOfflineScreen))
        setupView()
        addDoubleTapHandling()
        
        locationService.load { [unowned self] (error, location) in
            guard let coord = location else {
                return
            }
            
            self.addPin(to: coord)
            self.centerMapOnLocation(coord)
        }
    }
    
    @objc func presentOfflineScreen() {
        let models = StorageService.loadData()
        navigationController?.pushViewController(OfflineListVC(models: models), animated: true)
    }
    
    func setupView() {
        view.addSubview(mapView)
        mapView.isZoomEnabled = false
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addDoubleTapHandling() {
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(gestureAction))
        gesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(gesture)
        tap = gesture
    }
    
    @objc func gestureAction(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coord = mapView.convert(point, toCoordinateFrom: mapView)
        addPin(to: coord)
        navigationController?.pushViewController(WeatherDetailsVC(location: coord), animated: true)
    }
    
    func addPin(to coordinate: CLLocationCoordinate2D) {
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 10000, 10000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
