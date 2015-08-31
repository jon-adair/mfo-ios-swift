//
//  EventDetailTableViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/30/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import UIKit


class EventDetailTableViewController : UITableViewController {
 
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventCost: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventAdditionalInfo: UILabel!
    
    var event:Event?
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
    }*/
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        /*
        eventAdditionalInfo.sizeToFit()
        eventDescription.sizeToFit()
        eventAdditionalInfo.layoutIfNeeded()
        eventDescription.layoutIfNeeded()
        */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}