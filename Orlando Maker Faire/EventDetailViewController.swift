//
//  EventDetailViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 7/12/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//


import UIKit

class EventDetailViewController : UIViewController {

    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet var eventImage: UIImageView!
    
    
    var event : Event?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            //print("Loaded cached image")
            return UIImage(data: data!)!
        } else {
            print("no cached image for: ", filename.path)
        }
        
        
        let url = URL(string: link!)
        let data = try? Data(contentsOf: url!)
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(event?.description)
        self.title = event?.name
        
        eventTitle.text = event?.name
        eventLocation.text = event?.location
        if ( event?.end_time != nil && event?.end_time != "" )  {
            let timeText = (event?.start_time)! + " - " + (event?.end_time)!
            eventTime.text = timeText
        } else {
            eventTime.text = event?.start_time
        }
        
        // Much easier to just combine all of these since not all are present for each event
        var eventText = ""
        if ( event?.cost != nil && event?.cost != "" ) {
            eventText = eventText + (event?.cost)! + "\r"
        }
        if ( event?.description != nil && event?.description != ""  ) {
            eventText = eventText + (event?.description)! + "\r"
        }
        if ( event?.additional_info != nil && event?.additional_info != "" ) {
            eventText = eventText + (event?.additional_info)! + "\r"
        }
        
        eventDescription.text = eventText
        
        eventImage.image = getImage(link: event?.image_large)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
