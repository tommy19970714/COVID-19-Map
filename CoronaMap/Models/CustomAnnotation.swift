//
//  CustomAnnotation.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var feature: Feature?
    var circle: MKCircle?
}
