//
//  ViewController.swift
//  NYTimesTestApp
//
//  Created by Abhishek Chaudhari on 17/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit

class NewsFeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let newsCellIdentifier = "NewsCellIdentifier"
    var newsResults = [Results]()
    
    //activity indicator for API fetch
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    //MARK: - VC life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newsTableView.rowHeight = UITableViewAutomaticDimension;
        
        //start activity animation before calling API
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.center = view.center
        self.activityIndicator.startAnimating()

        //fetch news from API
        let newsFetcher = NewsFetcher()
        newsFetcher.fetchMostPopulorNews() { (results, status) in
            if(status == "OK"){
                self.newsResults = results
                
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: "Issue fetching news!!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            defer{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellIdentifier, for: indexPath) as! NewsCell
        let result = newsResults[indexPath.row]
        
        do{
            try cell.updateCell(news: result)
        } catch _ {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "newsDetailsSegue", sender: newsResults[indexPath.row].url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newsDetails = segue.destination as? NewsDetailsVC else {
            return
        }
        newsDetails.newsURL = sender as! String
    }
}

