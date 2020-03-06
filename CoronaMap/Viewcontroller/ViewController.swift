//
//  ViewController.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var totalView: TotalView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    var fpc: FloatingPanelController!
    
    var locationManager: CLLocationManager!
    
    var features = [Feature]()
    var circles = [MKCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup mapview
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        
        // request api
        let api = CoronavirusAPI()
        api.request(callback: { features, error in
            self.features = features
            self.showAnnotations()
            self.showOverlays()
            self.totalView.setFeature(features: features)
        })
        requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addShadow(attachView: totalView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func tappedLocationButton(_ seder: UIButton) {
        setLocation()
    }
    
    func pinTapCount() {
        let key = "pinTapCount"
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: key) + 1, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func addShadow(attachView: UIView) {
        let shadowView = UIView(frame: attachView.frame)

        shadowView.layer.cornerRadius = 10
        shadowView.layer.masksToBounds = false

        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowRadius = 10

        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 2).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale

        view.addSubview(shadowView)
        view.bringSubviewToFront(attachView)
    }

}

extension ViewController: FloatingPanelControllerDelegate {
    
    func openModal(feature: Feature) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fpc = FloatingPanelController()
        
        let contentVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        contentVC.feature = feature
        fpc.set(contentViewController: contentVC)
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.cornerRadius = 20.5
        fpc.surfaceView.shadowHidden = false
        fpc.delegate = self

        self.present(fpc, animated: true, completion: nil)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return PanelLayout()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func setLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 50
        if (locationManager != NSNull()) {
            locationManager?.delegate = self
            
            let status = CLLocationManager.authorizationStatus()
            switch status{
            case .restricted, .denied:
                break
            case .notDetermined:
                if ((locationManager?.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) != nil){
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    locationManager?.requestWhenInUseAuthorization()
                    locationManager?.startUpdatingLocation()
                }else{
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                    locationManager?.startUpdatingLocation()
                }
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager?.startUpdatingLocation()
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude {
            let location = CLLocationCoordinate2DMake(latitude,longitude)
            
            var region: MKCoordinateRegion = mapView.region
            region.center = location
            mapView.setRegion(region, animated: true)
            
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

extension ViewController: MKMapViewDelegate {
    
    func showAnnotations() {
        for feature in features {
            mapView.addAnnotation(feature.annotation())
        }
    }
    
    func showOverlays() {
        mapView.removeOverlays(circles)
        circles = []
        
        for feature in features {
//            let delta = mapView.region.span.longitudeDelta
//            let distance = CalcUtils.relativeDistance(delta: delta, confirm: feature.attributes.Confirmed)
            let distance = CalcUtils.absoluteDistance(confirm: feature.attributes.Confirmed)
            let circle: MKCircle = MKCircle(center: feature.coordinate(), radius: CLLocationDistance(distance))
            circles.append(circle)
            mapView.addOverlay(circle)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        showOverlays()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomPointAnnotation else { return }
        if let feature = annotation.feature {
            mapView.region.center = annotation.coordinate
            openModal(feature: feature)
            pinTapCount()
            NotificationCenter.default.post(name: .tappedAnnotation, object: nil, userInfo: ["feature": feature])
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let circleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = UIColor.red
        circleView.strokeColor = UIColor.clear
        circleView.alpha = 0.30
        circleView.lineWidth = 0

        return circleView
    }
}

extension Notification.Name {
    static let tappedAnnotation = Notification.Name("tappedAnnotation")
}
