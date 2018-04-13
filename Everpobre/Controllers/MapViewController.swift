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

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    
    let mapView : MKMapView = {
       let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    let directionText : UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUIView()
        
        setupCancelNavigation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    func SetupUIView(){
        
        view.addSubview(mapView)
        view.addSubview(directionText)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            directionText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            directionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            directionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            directionText.heightAnchor.constraint(equalToConstant: 50)
        ])
        mapView.delegate = self
        directionText.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        
        let centerCoordinate = mapView.centerCoordinate
        let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mapView.isScrollEnabled = false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mapView.isScrollEnabled = true
        
        if (!(directionText.text?.isEmpty)!){
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(directionText.text!) { (placemarkArray, err) in
                
                DispatchQueue.main.async {
                    if let placemark = placemarkArray?.first{
                        let region = MKCoordinateRegion(center: (placemark.location?.coordinate)!, span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        self.mapView.setRegion(region, animated: true)
                    }
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func handleSave(){
        print("Saving Map")
//        if notebook == nil {
//            CreateNotebook()
//        }else{
//            saveNotebookChanges()
//        }
    }

}


