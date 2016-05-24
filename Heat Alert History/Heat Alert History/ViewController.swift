//
//  ViewController.swift
//  Heat Alert History
//
//  Created by Student on 2016-05-23.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    
    let dateLabel = UITextField(frame: CGRect(x: 0, y: 0,width: 300, height: 30))
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Source JSON is here:
            // http://app.toronto.ca/opendata/heat_alerts/heat_alerts_list.json
            //
            let heatAlerts = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            
            // Iterate over all the objects
            for heatAlert in heatAlerts {
                
                // Cast it to a dictionary with a string key
                if let heatAlertDetails = heatAlert as? [String : String] {
                    
                    guard let date : String = heatAlertDetails["date"]! as String,
                        let text : String = heatAlertDetails["text"]! as String
                        
                        else{
                            print("Error")
                            return
                    }
                    
                    print("==========")
                    print("Date: \(date)")
                    print("\(text)")
                }
                
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        } catch {
            print("something else bad happened")
        }
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://app.toronto.ca/opendata/heat_alerts/heat_alerts_list.json"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()
        
        // Make the view's background be gray
        view.backgroundColor = UIColor.redColor()
        
        /*
         * Create and position the label
         */
        let title = UILabel()
        
        // Set the label text and appearance
        title.text = "Heat Alert History"
        title.font = UIFont.boldSystemFontOfSize(36)
        
        // Required to autolayout this label
        title.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(title)
        
        /*
         * Create and position the label
         */
        let date = UILabel()
        
        // Set the label text and appearance
        date.text = "Date"
        date.font = UIFont.boldSystemFontOfSize(20)
        
        // Required to autolayout this label
        date.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(date)
        
        
        /*
         * Create label for the amount field
         */
        
        // Set the label text and appearance
        dateLabel.borderStyle = UITextBorderStyle.RoundedRect
        dateLabel.font = UIFont.systemFontOfSize(15)
        dateLabel.placeholder = "YYYY-MM-DD"
        dateLabel.backgroundColor = UIColor.whiteColor()
        dateLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        // Required to autolayout this field
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the amount albel into the superview
        view.addSubview(dateLabel)
        
        
        //        /*
        //         * Further define label that will show JSON data
        //         */
        //
        //        // Set the label text and appearance
        //        jsonResult.text = "..."
        //        jsonResult.font = UIFont.systemFontOfSize(12)
        //        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        //        // e.g.: multiple lines will show up
        //        jsonResult.textAlignment = NSTextAlignment.Center
        //
        //        // Required to autolayout this label
        //        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        //
        //        // Add the label to the superview
        //        view.addSubview(jsonResult)
        
        
        
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Search", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = ["title": title, "date": date, "inputField": dateLabel,
                                                      "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[title]-40-[date][inputField]-50-[getData]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}
