//
//  File.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/12/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import Foundation

class Event {
    
    var name:String?
    var image_large:String?
    var description:String?
    var date:String?
    var start_time:String?
    var end_time:String?
    var duration:String?
    var cost:String?
    var additional_info:String?
    var location:String?
    
    init(name:String?,
         image_large:String?,
         description:String?,
         date:String?,
         start_time:String?,
         end_time:String?,
         duration:String?,
         cost:String?,
         additional_info:String?,
         location:String?)
    {
        self.name = name
        self.image_large = image_large
        self.description = description
        self.date = date
        self.start_time = start_time
        self.end_time = end_time
        self.duration = duration
        self.cost = cost
        self.additional_info = additional_info
        self.location = location
    }
}
