//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Jayne Vidheecharoen on 10/20/14.
//  Copyright (c) 2014 Jayne Vidheecharoen. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var photos: NSArray! = []
    var photo: NSDictionary!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        var clientId = "ab15ec635b5a48d793872110b69dc27b"
        
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as NSArray
            self.tableView.reloadData()
            
            println("response: \(self.photos)")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Determine which row was selected
        var cell = sender as PhotoTableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        println(indexPath)
        
        // Get the view controller that we're transitioning to.
        var photoDetailsViewController = segue.destinationViewController as PhotoDetailsViewController
        
        // Set the data of the view controller
        var photo = photos[indexPath.section] as NSDictionary
        var photoURL = photo.valueForKeyPath("images.low_resolution.url") as? String
        
        println("my phot url is \(photoURL!)")
        
        photoDetailsViewController.photoURL = photoURL
    }
    
    
    //#pragma mark - Table view methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photos.count
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as PhotoTableViewCell
        
        var photo = photos[indexPath.section] as NSDictionary
        var photoURL = photo.valueForKeyPath("images.low_resolution.url") as? String
        cell.urlLabel.text = photoURL
        
        cell.photoView.setImageWithURL(NSURL(string: photoURL!))
        
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        var photo = photos[section] as NSDictionary
        var user = photo["user"] as NSDictionary
        var username = user["username"] as String
        var profileUrl = NSURL(string: user["profile_picture"] as String)
        
        var profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        profileView.setImageWithURL(profileUrl)
        headerView.addSubview(profileView)
        
        var usernameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 250, height: 30))
        usernameLabel.text = username
        usernameLabel.font = UIFont.boldSystemFontOfSize(16)
        usernameLabel.textColor = UIColor(red: 8/255.0, green: 64/255.0, blue: 127/255.0, alpha: 1)
        headerView.addSubview(usernameLabel)
        
        return headerView
    }
}
