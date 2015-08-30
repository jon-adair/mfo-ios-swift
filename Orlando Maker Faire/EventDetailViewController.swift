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
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventAdditionalInfo: UITextView!
   
    
    
    var event : Event?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println(event?.description)
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
        
        
        // longer stuff
      
        eventDescription.text = event?.description
        eventAdditionalInfo.text = event?.additional_info
        eventAdditionalInfo.sizeToFit()
        eventDescription.sizeToFit()
        eventAdditionalInfo.layoutIfNeeded()
        eventDescription.layoutIfNeeded()
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}