//
//  CalendarAPI.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/12/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import Foundation

protocol EventAPIProtocol {
    func didReceiveAPIResults(_ results: NSDictionary)
}

class EventAPI {
    
    var delegate: EventAPIProtocol?
    
    init(delegate: EventAPIProtocol?) {
        self.delegate = delegate
    }
    
    func getEvents() {
        let urlPath = "https://makerfaireorlando.com/events-json"
        let url: URL = URL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!)
                return
            }
            // WARNING: This dies when no connection is available
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Got event data")
                //print("Everyone is fine, file downloaded successfully.")
                //print(data)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("Event results recieved")
                    // Now send the JSON result to our delegate object
                    self.delegate?.didReceiveAPIResults(jsonResult)
                } catch let error as NSError {
                    print("HTTP Error: \(error.localizedDescription)")
                }
            } else {
                print("No event data: \(statusCode)")
                print("URL: \(urlRequest)")
            }
        }
        
        task.resume()
    }
}


