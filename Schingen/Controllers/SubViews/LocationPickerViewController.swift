//
//  LocationPickerViewController.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 16.11.2021.
//

import UIKit
import CoreLocation
import MapKit

/// This controller manage the location messages for the pick coordinates from map and shows the exist coordinates which is came from messages on map
final class LocationPickerViewController: UIViewController {

    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        self.isPickable = coordinates == nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        view.backgroundColor = .systemBackground
        
// MARK: Provide the coordinates from map to sending location.
        if isPickable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))
            map.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(didTapMap(_:)))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            map.addGestureRecognizer(gesture)
        }
        else {
// MARK: Just showing location for the location messages. Runs when user tap the location messages.
            guard let coordinates = self.coordinates else {
                return
            }
//            Zoom arrangement of Map
            let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:0.01)
            let region = MKCoordinateRegion.init(center: coordinates, span: span)
            map.setRegion(region, animated: false)
            map.showsUserLocation = true
            
//          Droping a pin on selected location.
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
    }
    /// Send button actions provided.
    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else { return }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }
    /// Map taping actions provided.
    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates

        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

}
