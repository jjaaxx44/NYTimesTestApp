//
//  NYTimesTestAppTests.swift
//  NYTimesTestAppTests
//
//  Created by Abhishek Chaudhari on 17/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import XCTest
import WebKit

@testable import NYTimesTestApp

let correctJson = "{\"status\":\"OK\",\"copyright\":\"Copyright (c) 2018 The New York Times Company.  All Rights Reserved.\",\"num_results\":1684,\"results\":[{\"url\":\"https://www.nytimes.com/2018/08/13/nyregion/sexual-harassment-nyu-female-professor.html\",\"byline\":\"byline text\",\"title\":\"title text\",\"id\":100000006044436,\"media\":[{\"type\":\"image\",\"subtype\":\"photo\",\"caption\":\"caption text.\",\"media-metadata\":[{\"url\":\"url text\",\"format\":\"Large Thumbnail\",\"height\":150,\"width\":150}]}]}]}"

let noMediaJson = "{\"status\":\"OK\",\"copyright\":\"Copyright (c) 2018 The New York Times Company.  All Rights Reserved.\",\"num_results\":1684,\"results\":[{\"url\":\"https://www.nytimes.com/2018/08/13/nyregion/sexual-harassment-nyu-female-professor.html\",\"byline\":\"By ZOE GREENBERG\",\"title\":\"title text\",\"id\":100000006044436,\"media\":[]}]}"
let noMetaDataJson = "{\"status\":\"OK\",\"copyright\":\"Copyright (c) 2018 The New York Times Company.  All Rights Reserved.\",\"num_results\":1684,\"results\":[{\"url\":\"https://www.nytimes.com/2018/08/13/nyregion/sexual-harassment-nyu-female-professor.html\",\"byline\":\"By ZOE GREENBERG\",\"title\":\"title text\",\"id\":100000006044436,\"media\":[{\"type\":\"image\",\"subtype\":\"photo\",\"caption\":\"caption text.\"}]}]}"
let noThumbJson = "{\"status\":\"OK\",\"copyright\":\"Copyright (c) 2018 The New York Times Company.  All Rights Reserved.\",\"num_results\":1684,\"results\":[{\"url\":\"https://www.nytimes.com/2018/08/13/nyregion/sexual-harassment-nyu-female-professor.html\",\"byline\":\"By ZOE GREENBERG\",\"title\":\"title text\",\"id\":100000006044436,\"media\":[{\"type\":\"image\",\"subtype\":\"photo\",\"caption\":\"caption text.\",\"media-metadata\":[{\"format\":\"Large Thumbnail\",\"height\":150,\"width\":150}]}]}]}"

class NYTimesTestAppTests: XCTestCase {
    
    var newsFeedVC: NewsFeedVC!
    var newsDetailsVC: NewsDetailsVC!
    var newsObject: Results!
    override func setUp() {
        super.setUp()
        
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        newsFeedVC = storyboard.instantiateViewController(withIdentifier: "NewsFeedVC") as! NewsFeedVC
        newsDetailsVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailsVC") as! NewsDetailsVC
        
        //load view hierarchy
        if(newsFeedVC != nil) {
            
            newsFeedVC.loadView()
            newsFeedVC.viewDidLoad()
        }
        
        if(newsDetailsVC != nil) {
            newsDetailsVC.newsURL = ""
            newsDetailsVC.loadView()
            newsDetailsVC.viewDidLoad()
        }
    }
    
    //checking api response for OK or count of results
    func testAPIResponce(){
        
        
        newsFeedVC.loadView()
        newsFeedVC.viewDidLoad()

        let expect = expectation(description: "apiwait")
        
        let newsFetcher = NewsFetcher()
        newsFetcher.fetchMostPopulorNews { (results, status) in
            XCTAssertEqual(status, "OK")
            XCTAssertTrue(results.count > 0)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 50) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testAPIWrongURLResponce(){
        let expect = expectation(description: "apiwait")
        
        let newsFetcher = NewsFetcher()
        newsFetcher.fetchMostPopulorNews(url: "https://api.nytimes.com") { (results, status) in
            XCTAssertEqual(status, "FAILED")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 50) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testAPIFailResponce(){
        let expect = expectation(description: "apiwait")
        
        let newsFetcher = NewsFetcher()
        newsFetcher.fetchMostPopulorNews(url: "") { (results, status) in
            XCTAssertEqual(status, "FAILED")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 50) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testAPINilResponce(){
        let expect = expectation(description: "apiwait")
        
        let newsFetcher = NewsFetcher()
        newsFetcher.parseData(data: nil) { (results, status) in
            XCTAssertEqual(status, "FAILED")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 50) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func testNewFeedVCCompositioin(){
        XCTAssertNotNil(newsFeedVC.newsTableView, "NewsFeedVC does not compose of a tableview")
        XCTAssert(newsFeedVC.conforms(to: UITableViewDelegate.self), "NewsFeedVC does not conform to UITableViewDelegate protocol")
        XCTAssert(newsFeedVC.conforms(to: UITableViewDataSource.self), "NewsFeedVC does not conform to UITableViewDataSource protocol")
    }
    
    func testNewsDetailsVCCompositioin(){
        let targetSegue: UIStoryboardSegue = UIStoryboardSegue(identifier: "newsDetailsSegue", source: newsFeedVC, destination: newsDetailsVC)
        
        newsFeedVC.prepare(for: targetSegue, sender: "https://www.google.co.in/")
        newsDetailsVC.loadView()
        newsDetailsVC.viewDidLoad()
        XCTAssertEqual("https://www.google.co.in/", newsDetailsVC.newsWebView.url?.absoluteString)
        
        newsDetailsVC.newsWebView.navigationDelegate?.webView!(newsDetailsVC.newsWebView, didStartProvisionalNavigation: nil)
        XCTAssertEqual(newsDetailsVC.activityIndicator.isAnimating, true)
        
        newsDetailsVC.newsWebView.navigationDelegate?.webView!(newsDetailsVC.newsWebView, didFinish: nil)
        XCTAssertEqual(newsDetailsVC.activityIndicator.isAnimating, false)
    }
    
    func testCustomViewExtension(){
        let view = UIView.init(frame: CGRect.zero)
        view.addBorder(cornerRadius: 10.0, borderColor: UIColor.black, borderWidth: 10.0)
        XCTAssertEqual(view.layer.borderWidth, 10.0)
        XCTAssertEqual(view.layer.cornerRadius, 10.0)
        XCTAssertEqual(view.layer.borderColor, UIColor.black.cgColor)
    }

    func testForBadJson(json: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        let data = json.data(using: .utf8)!
        do {
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(MostViewed.self, from: data)
            self.newsFeedVC.newsResults = responseModel.results!
        }catch let err {
            print(err)
        }
        
        let cell = self.newsFeedVC.tableView(self.newsFeedVC.newsTableView, cellForRowAt: indexPath) as! NewsCell
        
        XCTAssertThrowsError(try cell.updateCell(news: self.newsFeedVC.newsResults[0])) { error in
            XCTAssertEqual(error as! DataError, DataError.DataMissingError)
        }
    }
    
    func testTableViewCellForBadData() {
        self.testForBadJson(json: noMediaJson)
        self.testForBadJson(json: noMetaDataJson)
        self.testForBadJson(json: noThumbJson)
    }
    
    func testTableViewCellForGoodData() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        let data = correctJson.data(using: .utf8)!
        do {
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(MostViewed.self, from: data)
            self.newsFeedVC.newsResults = responseModel.results!
        }catch let err {
            print(err)
        }
        
        let cell = self.newsFeedVC.tableView(self.newsFeedVC.newsTableView, cellForRowAt: indexPath) as! NewsCell
        
        XCTAssertEqual(cell.titleLable.text, "title text")
        XCTAssertEqual(cell.byLineLabel.text, "byline text")        
    }


    func testSUT_PassesDataToTargetViewController() {
        
        // fetch the segue from story board
        let targetSegue: UIStoryboardSegue = UIStoryboardSegue(identifier: "newsDetailsSegue", source: newsFeedVC, destination: newsDetailsVC)
        
        newsFeedVC.prepare(for: targetSegue, sender: "testurl")
        
        XCTAssertEqual("testurl", newsDetailsVC.newsURL)
    }
    
}

