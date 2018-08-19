//
//  NewsDetailsVC.swift
//  NYTimesTestApp
//
//  Created by Abhishek Chaudhari on 19/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailsVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var newsWebView: WKWebView!

    var newsURL: String!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"as", style:.plain, target:nil, action:nil)

        guard let url = URL(string: newsURL) else {
            return
        }
        newsWebView.navigationDelegate = self
        newsWebView.load(URLRequest(url: url))
        
        let rightBarItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
