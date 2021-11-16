//
//  LocationPickerViewController.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 16.11.2021.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private let map: MKMapView = {
        let map = MKMapView()
        
        
       return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        mapGestureConfigure()
    }
    
    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }

        completion?(coordinates)
    }
    
    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
        
//        drop pin the location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        frameSetUp()
    }
    
    private func setView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))
        view.addSubview(map)
    }
    
    private func frameSetUp() {
        map.frame = view.bounds
        title = "Pick Location"
        view.backgroundColor = .systemBackground
    }
    
    private func mapGestureConfigure() {
        map.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        map.addGestureRecognizer(gesture)
    }

}
