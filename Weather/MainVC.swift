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
        gesture.cancelsTouchesInView = true
        gesture.delegate = self
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
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MainVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == tap {
            return false
        } else {
            return true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
