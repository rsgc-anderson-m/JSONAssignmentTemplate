//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    let dateGiven = UITextField(frame: CGRect(x: 0, y: 0,width: 300, height: 30))
    let heatLabel = UILabel()
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        var heatMoney : String = ""
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Source JSON is here:
            // http://app.toronto.ca/opendata/heat_alerts/heat_alerts_list.json
            //
            let heatAlerts = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            
            guard let dateProvided : String = dateGiven.text else {
                print("No date given")
                return
            }
            
            print("The date given is: \(dateProvided)")
            
            heatMoney = "No Heat Alert"
            
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
                    
                    if let dateProvided = dateGiven.text {
                        if dateProvided==date {
                            heatMoney = text
                        }
                    }
                }
                
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        } catch {
            print("something else bad happened")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.heatLabel.text = heatMoney
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
         * Create and position the label
         */
        
        
        // Set the label text and appearance
        heatLabel.text = "Heat Alert"
        heatLabel.font = UIFont.boldSystemFontOfSize(11)
        // Required to autolayout this label
        heatLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(heatLabel)
        
        
        /*
         * Create label for the amount field
         */
        
        // Set the label text and appearance
        dateGiven.borderStyle = UITextBorderStyle.RoundedRect
        dateGiven.font = UIFont.systemFontOfSize(15)
        dateGiven.placeholder = "YYYY-MM-DD"
        dateGiven.backgroundColor = UIColor.whiteColor()
        dateGiven.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        // Required to autolayout this field
        dateGiven.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the amount albel into the superview
        view.addSubview(dateGiven)
        
        
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
        let viewsDictionary : [String : AnyObject] = ["title": title, "date": date, "inputField": dateGiven, "heat": heatLabel,
                                                      "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[title]-50-[date][inputField]-20-[getData]-10-[heat]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}

// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
