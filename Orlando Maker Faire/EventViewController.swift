//
//  SecondViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/8/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EventAPIProtocol {
    
    @IBOutlet weak var daySegmentedControl: UISegmentedControl!
    let kCellIdentifier: String = "EventCell"
    
    var api: EventAPI?
    
    @IBOutlet var eventTableView : UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    
    
    var events: [[Event]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = EventAPI(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.api?.getEvents()
        self.daySegmentedControl.addTarget(self, action: #selector(EventViewController.handleSegment(_:)), for: UIControlEvents.valueChanged)
        
        // If we're on day 2 of the event, default the view to day 2 (segment 1)
        // Kind of cheesy to do it this way.
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let convertedDate = dateFormatter.string(from: currentDate)
        print(convertedDate)
        if convertedDate == "10/23/2016" {
            self.daySegmentedControl.selectedSegmentIndex = 1
        }
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:50, height:50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.startAnimating();
        self.view.addSubview(activityIndicator)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.events.count == 1 && self.events[0].count == 0 {
            return 0
        }
        return self.events[daySegmentedControl.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)
        
        
        let event = self.events[daySegmentedControl.selectedSegmentIndex][(indexPath as NSIndexPath).row]
        cell.textLabel!.text = event.name
        cell.detailTextLabel!.text = event.location
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let detailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
        let eventIndex = eventTableView.indexPathForSelectedRow!.row
        let selectedEvent = self.events[daySegmentedControl.selectedSegmentIndex][eventIndex]
        detailViewController.event = selectedEvent
        
    }
    
    func didReceiveAPIResults(_ results: NSDictionary) {
        let days: NSArray = results["days"] as! NSArray
        self.events.append([Event]())
        let count = days.count - 1
        for dayCounter in 0...count {
            let day: NSDictionary = days[dayCounter] as! NSDictionary
            let date_title = day["date_title"] as! NSString
            // daySegmentedControl.setTitle(day["date_title"] as! String!, forSegmentAtIndex: 0)
            print("date_title = \(date_title)")
            let ev: [NSDictionary] = day["events"] as! [NSDictionary]
            for e in ev {
                //let name = e["name"] as! NSString
                //println("name = \(name)")
                
                var name: String? = e["name"] as? String
                var image_large: String? = e["image_large"] as? String
                var description: String? = e["description"] as? String
                var date: String? = e["date"] as? String
                var start_time: String? = e["start_time"] as? String
                var end_time: String? = e["end_time"] as? String
                var duration: String? = e["duration"] as? String
                var cost: String? = e["cost"] as? String
                var additional_info: String? = e["additional_info"] as? String
                var location: String? = e["location"] as? String
                /*
                var link: String? = e["promo_url"] as? String
                
                var startString : String = "1/1/90" // startDict["dateTime"] as! String
                var endString : String = "1/2/91" // endDict["dateTime"] as! String
                
                var formatter: NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'-'HH':'mm'"
                
                var start: NSDate = NSDate.new()
                var end: NSDate = NSDate.new()
*/
                
                //var newEvent = Event(summary: summary, event_description: event_description, location: location, link: link, start: start, end: end)
                var newEvent = Event(name: name, image_large: image_large, description: description, date: date, start_time: start_time, end_time: end_time, duration: duration, cost: cost, additional_info: additional_info, location: location)
                print(newEvent)
                
                self.events[dayCounter].append(newEvent)
            }
        }
        
//        let allResults: [NSDictionary] = results["items"] as! [NSDictionary]
//        for result:NSDictionary in allResults {
//            
//            var location: String? = result["location"] as? String
//            var link: String? = result["htmllink"] as? String
//            var event_description: String? = result["description"] as? String
//            var summary: String? = result["summary"] as? String
//            
//            
//            var formatter: NSDateFormatter = NSDateFormatter()
//            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'-'HH':'mm'"
//            var startDict : NSDictionary = result["start"] as! NSDictionary
//            var endDict : NSDictionary = result["end"] as! NSDictionary
//            
//            var startString : String = startDict["dateTime"] as! String
//            var endString : String = endDict["dateTime"] as! String
//            
//            println(startString)
//            
//            var start: NSDate = formatter.dateFromString(startString)!
//            var end: NSDate = formatter.dateFromString(endString)!
//            println(start)
//            
//            
//            var newEvent = Event(summary: summary, event_description: event_description, location: location, link: link, start: start, end: end)
//            
//            self.events.append(newEvent)
//        }
//       
        // Need to do this back on the main thread because this gets called by an asynch background thread
        DispatchQueue.main.async{
            self.activityIndicator.removeFromSuperview()
            self.eventTableView.reloadData()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func handleSegment(_ daySegment: UISegmentedControl) {
        print("sel = \(daySegment.selectedSegmentIndex)")
        self.eventTableView.reloadData()
    }
}
