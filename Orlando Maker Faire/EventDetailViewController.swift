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
        
        if ( event?.image_large != nil ) {
            
            let url = URL(string: (self.event?.image_large!)!)
            let data = try? Data(contentsOf: url!)
            if ( data != nil ) {
                self.eventImage.image = UIImage(data: data!)
            } else {
                eventImage.image = UIImage(named: "makey")
            }
        } else {
            eventImage.image = UIImage(named: "makey")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
