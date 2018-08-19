//
//  NewsFetcher.swift
//  NYTimesTestApp
//
//  Created by Abhishek Chaudhari on 19/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NewsFetcher{
    
    func fetchMostPopulorNews(url: String = API.GET_NEWS_DATA_API, completionClosure: @escaping (_ indexes: [Results], _ status : String)-> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
        Alamofire.request(url,method: .get, encoding: JSONEncoding.default).responseJSON { response in
            self.parseData(data: response.data, completionClosure: completionClosure)
        }
    }
    
    func parseData(data: Data?, completionClosure: @escaping (_ indexes: [Results], _ status : String)-> ()){
        do {
            guard let data = data else {
                completionClosure([], "FAILED")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(MostViewed.self, from: data)
            
            guard let status = responseModel.status else{
                completionClosure([], "FAILED")
                return
            }

            if (status == "OK"){
                let newsResults = responseModel.results!
                
                completionClosure(newsResults, status)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }catch let err {
            print(err)
            completionClosure([], "FAILED")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
