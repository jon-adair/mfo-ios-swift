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
    @IBOutlet var eventTableView : UITableView!
    let kCellIdentifier: String = "EventCell"
    var api: EventAPI?
    var activityIndicator: UIActivityIndicatorView!
    var initialLoad = true
    var events: [[Event]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = EventAPI(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.api?.getEvents(refresh:false)
        self.daySegmentedControl.addTarget(self, action: #selector(EventViewController.handleSegment(_:)), for: UIControl.Event.valueChanged)
        
        // If we're on day 2 of the event, default the view to day 2 (segment 1)
        // Kind of cheesy to do it this way.
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let convertedDate = dateFormatter.string(from: currentDate)
        print(convertedDate)
        if convertedDate == "11/10/2019" {
            self.daySegmentedControl.selectedSegmentIndex = 1
        }
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:50, height:50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating();
        self.view.addSubview(activityIndicator)
        self.view.addSubview(self.refreshControl)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeLeft() {
        if self.daySegmentedControl.selectedSegmentIndex == 1 { return }
        self.daySegmentedControl.selectedSegmentIndex = 1
        self.eventTableView.reloadData()
    }
    @objc func swipeRight() {
        if self.daySegmentedControl.selectedSegmentIndex == 0 { return }
        self.daySegmentedControl.selectedSegmentIndex = 0
        self.eventTableView.reloadData()
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(EventViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refresh")
        self.api?.getEvents(refresh:true)
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImage(link:String?) -> UIImage {
        if ( link == nil || link == "") {
            return UIImage(named: "makey")!
        }
        var path: String?
        //print("Starting with url: ", link!)
        if link!.hasPrefix("https://www.makerfaireorlando.com/wp-content/uploads/") {
            path = String(link!.dropFirst(53))
        } else if link!.hasPrefix("https://") {
            path = String(link!.dropFirst(8))
        }
        //print("Stripped url: ", path!)
        
        path = path!.replacingOccurrences(of: "/", with: "-")
        //print("File path: ", path!)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent(path!)
        
        if FileManager.default.fileExists(atPath: filename.path) {
            // not going to bother checking cached timestamps on images since they should have a different URL if they're re-uploaded
            let url = URL(string: filename.absoluteString)
            let data = try? Data(contentsOf: url!)
            if data == nil || data?.count == 0 {
                return UIImage(named: "makey")!
            }

            //print("Loaded cached image")
            return UIImage(data: data!)!
        } else {
            print("no cached image for: ", filename.path)
        }
        
        let url = URL(string: link!)
        let data = try? Data(contentsOf: url!)
        if data == nil || data?.count == 0 {
            return UIImage(named: "makey")!
        }

        do {
            try data!.write(to: filename)
            //print("wrote image to:", filename)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("failed to write image file")
        }
        
        return UIImage(data: data!)!
        //cell.imageView?.image = UIImage(data: data!)
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
        cell.detailTextLabel!.text = "\(event.start_time!) \(event.location!)"
        
        if self.initialLoad {
            // clumsy lazy-load instead
            cell.imageView?.image = UIImage(named: "makey-blurred")
        } else {
            // now that the images are cached just use them directly so we don't flash a tiny makey at all
            cell.imageView?.image = self.getImage(link: event.image_large)
        }
        // force imageviews to same size
        // https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
        let itemSize = CGSize.init(width: 44, height: 44)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell?.imageView?.image!.draw(in: imageRect)
        cell?.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();

        cell.tag = indexPath.row
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let image = self.getImage(link: event.image_large)
            
            DispatchQueue.main.async{
                if(cell.tag == indexPath.row) {
                    cell.imageView?.image = image
                    // force imageviews to same size
                    // https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
                    let itemSize = CGSize.init(width: 44, height: 44)
                    UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                    let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                    cell?.imageView?.image!.draw(in: imageRect)
                    cell?.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                    UIGraphicsEndImageContext();

                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let detailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
        let eventIndex = eventTableView.indexPathForSelectedRow!.row
        let selectedEvent = self.events[daySegmentedControl.selectedSegmentIndex][eventIndex]
        detailViewController.event = selectedEvent
        
    }
    
    func didReceiveAPIResults(_ results: NSDictionary) {
        events = [[]]

            //var events: [[Event]] = [[]]
        let days: NSArray = results["days"] as! NSArray
        
        self.events.append([Event]())
        let count = days.count - 1
        for dayCounter in 0...count {
            let day: NSDictionary = days[dayCounter] as! NSDictionary
            let date_title = day["date_title"] as! String
            //daySegmentedControl.setTitle(date_title, forSegmentAt: dayCounter) // really should go back to this but needs to be after order fix
            print("date_title = \(date_title)")
            let ev: [NSDictionary] = day["events"] as! [NSDictionary]
            for e in ev {
                
                let name: String? = e["name"] as? String
                let image_large: String? = e["image_large"] as? String
                let description: String? = e["description"] as? String
                let date: String? = e["date"] as? String
                let start_time: String? = e["start_time"] as? String
                let end_time: String? = e["end_time"] as? String
                let duration: String? = e["duration"] as? String
                let cost: String? = e["cost"] as? String
                let additional_info: String? = e["additional_info"] as? String
                let location: String? = e["location"] as? String
                let newEvent = Event(name: name, image_large: image_large, description: description, date: date, start_time: start_time, end_time: end_time, duration: duration, cost: cost, additional_info: additional_info, location: location)
                self.events[dayCounter].append(newEvent)
            }
        }
        
        // Can't rely on the JSON being in date order so need to re-sort the array
        // really hacky kludge to patch it for the moment
        // should use the top level date_title instead but that's not stored in this array
        if count == 1 {
            if self.events[0][0].date?.compare(self.events[1][0].date!) != ComparisonResult.orderedDescending {
                print("dates were out of order")
                self.events.swapAt(0,1)
            }
            print(self.events[0][0].date ?? "")
            print(self.events[1][0].date ?? "")
        }
        
        // Need to do this back on the main thread because this gets called by an asynch background thread
        DispatchQueue.main.async{
            self.activityIndicator.removeFromSuperview()
            self.eventTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            // Now start crawling images and caching them if we don't already have them
            for dayCounter in 0...count {
                for ev in self.events[dayCounter] {
                    _ = self.getImage(link: ev.image_large)
                }
            }
            self.initialLoad = false
        }
    }

    @objc func handleSegment(_ daySegment: UISegmentedControl) {
        print("sel = \(daySegment.selectedSegmentIndex)")
        self.eventTableView.reloadData()
    }
}
