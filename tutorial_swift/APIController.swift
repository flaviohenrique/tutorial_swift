//
//  APIController.swift
//  tutorial_swift
//
//  Created by Flavio Andrade on 7/8/15.
//  Copyright (c) 2015 Flavio Andrade. All rights reserved.
//

import Foundation

class APIController{
  var delegate: APIControllerProtocol?
  
  init(){}
  
  func searchItunesFor(searchTerm: String) {
    // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
    let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    
    // Now escape anything else that isn't URL-friendly
    if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
      let url = NSURL(string: urlPath)
      let session = NSURLSession.sharedSession()
      let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
        println("Task completed")
        if(error != nil) {
          // If there is an error in the web request, print it to the console
          println(error.localizedDescription)
        }
        var err: NSError?
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
          if(err != nil) {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(err!.localizedDescription)")
          }
          if let results: NSArray = jsonResult["results"] as? NSArray {
            self.delegate?.didReceiveAPIResults(results)
          }
        }
      })
      
      // The task is just an object with all these properties set
      // In order to actually make the web request, we need to "resume"
      task.resume()
    }
  }
}

protocol APIControllerProtocol {
  func didReceiveAPIResults(results: NSArray)
}