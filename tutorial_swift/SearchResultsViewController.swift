//
//  SearchResultsViewController.swift
//  tutorial_swift
//
//  Created by Flavio Andrade on 6/26/15.
//  Copyright (c) 2015 Flavio Andrade. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
  
  var tableData = []
  
  let api = APIController()
  
  @IBOutlet weak var appsTableView : UITableView!
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return tableData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
    
    let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
    let urlString = rowData["artworkUrl60"] as String
    let imgURL = NSURL(string: urlString)
    let formattedPrice = rowData["formattedPrice"] as String
    let imgData = NSData(contentsOfURL: imgURL!)
    let trackName = rowData["trackName"] as? String
    
    cell.detailTextLabel?.text = formattedPrice
    cell.imageView?.image = UIImage(data: imgData!)
    cell.textLabel?.text = trackName

    return cell
  }
  
  func didReceiveAPIResults(results: NSArray) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableData = results
      self.appsTableView!.reloadData()
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api.delegate = self
    api.searchItunesFor("JQ Software")
    
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

