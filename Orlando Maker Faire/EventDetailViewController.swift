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
    @IBOutlet weak var eventCost: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventAdditionalInfo: UILabel!
    
    
    var event : Event?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(event?.description)
        self.title = event?.name
        
        eventTitle.text = event?.name
        eventLocation.text = event?.location
        if event?.end_time != nil {
            var timeText = event?.start_time 
            
            eventTime.text = timeText
        } else {
            eventTime.text = event?.start_time
        }
        
        eventCost.text = event?.cost
        eventDuration.text = event?.duration
        eventDescription.text = event?.description
        eventAdditionalInfo.text = event?.additional_info

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
