//
//  GoogleNewsAPI.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation
import Alamofire

class GoogleNewsAPI: NSObject {
    
    let requestUrlEvery = "https://newsapi.org/v2/everything"
    let requestUrlHead = "https://newsapi.org/v2/top-headlines"
    let apiKey = "xxxxxxxxxxxxxxxx"

    internal func everything(callback:@escaping ([Article], NSError?)->Void)
    {
        let query = "corona"
        let parameters:[String: String] = [
            "apiKey": apiKey,
            "q": query,
            "sortBy": "publishedAt"
        ]
        print(parameters)
        Alamofire.request(requestUrlEvery, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess {
                    guard let data = response.data else { return }
                    do {
                        let model: NewsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                        callback(model.articles, nil)
                    } catch {
                        print("decode error")
                    }
                    
                }
        }
    }
    
    internal func headlines(callback:@escaping ([Article], NSError?)->Void)
        {
            let query = "corona"
            let parameters:[String: String] = [
                "apiKey": apiKey,
                "country": "us",
                "q": query,
                "sortBy": "publishedAt"
            ]
            Alamofire.request(requestUrlHead, parameters: parameters)
                .responseJSON { response in
                    if response.result.isSuccess {
                        guard let data = response.data else { return }
                        do {
                            let model: NewsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                            callback(model.articles, nil)
                        } catch {
                            print("decode error")
                        }
                    }
            }
        }

}
