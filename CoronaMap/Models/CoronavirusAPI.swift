//
//  CoronavirusAPI.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation
import Alamofire

class CoronavirusAPI: NSObject {
    
    let requestUrl = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultRecordCount=250&cacheHint=true"

    internal func request(callback:@escaping ([Feature], NSError?)->Void)
    {
        Alamofire.request(requestUrl)
            .responseJSON { response in
                if response.result.isSuccess {
                    guard let data = response.data else { return }
                    let model: FeatureServer = try! JSONDecoder().decode(FeatureServer.self, from: data)
                    callback(model.features, nil)
                }
        }
    }
}
