//
//  ViewController.swift
//  NYTimesTestApp
//
//  Created by Abhishek Chaudhari on 17/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let jsonUrlString = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=f0a8d85ae6de434fb3a73b03c8edf6af") else {
            return
        }
        
        URLSession.shared.dataTask(with: jsonUrlString) { (data, response, err) in
            if (err != nil) {
                print(err!)
            }
            do {
                guard let data = data else { return }
                
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(MostViewed.self, from: data)
                
                print(responseModel.status ?? -1)
                print(responseModel.num_results ?? -1)
            }catch let err {
                print(err)
            }
            
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

