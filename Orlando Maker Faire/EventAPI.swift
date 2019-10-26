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
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let filename = path.appendingPathComponent("events.json")
        
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath:filename.path)
            print(attributes)
            let timestamp = attributes[FileAttributeKey.modificationDate] as! Date
            print(attributes[FileAttributeKey.modificationDate] as? Date)
            let date2 = Date().addingTimeInterval(-43200) // 86400 secs = 1 day
            if timestamp < date2 {
                print("Cached events.json is old")
            } else {
                print("Cached events.json is new")
                let dataStr = try String(contentsOfFile: filename.path)
                let data = dataStr.data(using: .utf8)!
                let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print("Events results loaded")
                // Now send the JSON result to our delegate object
                self.delegate?.didReceiveAPIResults(jsonResult)
                return
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        let urlPath = "https://www.makerfaireorlando.com/events-json/"
        let url: URL = URL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        session.configuration.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
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
                    // Save it
                    do {
                        try data!.write(to: filename)
                        print("wrote events.json")
                    } catch {
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                        print("failed to write events.json")
                    }
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


