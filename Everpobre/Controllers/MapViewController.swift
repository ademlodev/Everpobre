//
//  MapViewController.swift
//  Everpobre
//
//  Created by Javi on 6/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

protocol MapViewControllerDelegate {
    func didEditMap(latitude: Double, longitude: Double)
}

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    var latitude: Double
    var longitude: Double
    
    let mapView : MKMapView = {
       let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    let directionText : UITextField = {
        let text = UITextField()
        text.placeholder = "Introduce direction"
        text.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let searchBtn : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: UIControlState.normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(searchText), for: .touchUpInside)

//        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
//        button.backgroundColor = UIColor.white
        return button
    }()
    
    var delegate: MapViewControllerDelegate?
    
    init(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: nil, bundle: Bundle (for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUIView()
        
        setupCancelNavigation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        if ( self.latitude != 0 && self.longitude != 0){
            let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(region, animated: false)
        }
    }
    
    func SetupUIView(){
        
        view.addSubview(mapView)
        view.addSubview(directionText)
        view.addSubview(searchBtn)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            directionText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            directionText.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            directionText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            directionText.heightAnchor.constraint(equalToConstant: 50),
            
            searchBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBtn.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            searchBtn.leftAnchor.constraint(equalTo: directionText.rightAnchor),
            searchBtn.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        //directionText.delegate = self
        mapView.delegate = self
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let centerCoordinate = mapView.centerCoordinate
        
        let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        self.latitude = centerCoordinate.latitude
        self.longitude = centerCoordinate.longitude
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placeMarkArray, err) in
            if let placeMark = placeMarkArray?.first {
                DispatchQueue.main.async {
                    if let postalAddress = placeMark.postalAddress {
                        self.directionText.text = "\(postalAddress.street) \(postalAddress.city)"
                    }
                }
            }
        }
    }
    
    @objc func searchText(sender:UIButton!){
        if (!(directionText.text?.isEmpty)!){
            let geocoder = CLGeocoder()

            geocoder.geocodeAddressString(directionText.text!) { (placemarkArray, err) in

                DispatchQueue.main.async {
                    if let placemark = placemarkArray?.first{
                        let region = MKCoordinateRegion(center: (placemark.location?.coordinate)!, span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        self.mapView.setRegion(region, animated: true)
                        self.latitude = (placemark.location?.coordinate.latitude)!
                        self.longitude = (placemark.location?.coordinate.longitude)!
                    }
                }

            }
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        mapView.isScrollEnabled = false
//
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        mapView.isScrollEnabled = true
//
//        if (!(directionText.text?.isEmpty)!){
//            let geocoder = CLGeocoder()
//
//            geocoder.geocodeAddressString(directionText.text!) { (placemarkArray, err) in
//
//                DispatchQueue.main.async {
//                    if let placemark = placemarkArray?.first{
//                        let region = MKCoordinateRegion(center: (placemark.location?.coordinate)!, span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1))
//                        self.mapView.setRegion(region, animated: true)
//                        self.latitude = (placemark.location?.coordinate.latitude)!
//                        self.longitude = (placemark.location?.coordinate.longitude)!
//                    }
//                }
//
//            }
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @objc func handleSave(){
        dismiss(animated: true){
            self.delegate?.didEditMap(latitude: self.latitude, longitude: self.longitude)
        }
    }
}


