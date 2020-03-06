//
//  DetailViewController.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit
import FloatingPanel
import CoreLocation

class DetailViewController: UIViewController {
    
    var feature: Feature?
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification(notification:)), name: .tappedAnnotation, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let feature = feature {
            setFeature(feature: feature)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func catchNotification(notification: Notification) -> Void {
        if let info = notification.userInfo, let feature = info["feature"] as? Feature {
            setFeature(feature: feature)
        }
    }
    
    func setFeature(feature: Feature) {
        regionLabel.text = feature.attributes.Country_Region
        confirmedLabel.text = String(feature.attributes.Confirmed)
        deathsLabel.text = String(feature.attributes.Deaths)
        recoveredLabel.text = String(feature.attributes.Recovered)
        
        let date = feature.date()
        print(feature.attributes.Last_Update)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyyhhmm", options: 0, locale: Locale.current)
        updateLabel.text = "Last Update " + formatter.string(from: date)
        
        if feature.administrativeArea != nil || feature.subAdministrativeArea != nil {
            return
        }
        
        let geocoder = CLGeocoder()
        let location = CLLocation.init(latitude: feature.attributes.Lat, longitude: feature.attributes.Long_)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {
                if let pm = placemarks.first, let country = pm.country, let administrative = pm.administrativeArea {
                    DispatchQueue.main.async {
                        if feature.attributes.Country_Region.contains("China") {
                            self.regionLabel.text = country + ", " + administrative
                        } else {
                            self.regionLabel.text = country
                        }
                        
                    }
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
