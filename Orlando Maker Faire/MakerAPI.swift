//
//  MakerAPI.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/12/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import Foundation

protocol MakerAPIProtocol {
    func didReceiveAPIResults(_ results: NSDictionary)
}

class MakerAPI {
    
    var delegate: MakerAPIProtocol?
    
    init(delegate: MakerAPIProtocol?) {
        self.delegate = delegate
    }
    
    func getMakers() {
        let urlPath = "https://www.makerfaireorlando.com/makers-json"
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
                print("Got maker data")
                //print("Everyone is fine, file downloaded successfully.")
                //print(data)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("Maker results recieved")
                    // Now send the JSON result to our delegate object
                    self.delegate?.didReceiveAPIResults(jsonResult)
                } catch let error as NSError {
                    print("HTTP Error: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}
