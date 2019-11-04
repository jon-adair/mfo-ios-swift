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
    
    func getMakers(refresh:Bool) {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let filename = path.appendingPathComponent("makers.json")

        if refresh {
            print("refreshing, skipping cache")
        } else {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath:filename.path)
                print(attributes)
                let timestamp = attributes[FileAttributeKey.modificationDate] as! Date
                print(attributes[FileAttributeKey.modificationDate] as? Date)
                let date2 = Date().addingTimeInterval(-43200) // 86400 = 1 day
                if timestamp < date2 {
                    print("Cached makers.json is old")
                } else {
                    print("Cached makers.json is new")
                    let dataStr = try String(contentsOfFile: filename.path)
                    let data = dataStr.data(using: .utf8)!
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("Maker results loaded")
                    // Now send the JSON result to our delegate object
                    self.delegate?.didReceiveAPIResults(jsonResult)
                    return
                }
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        
        let urlPath = "https://www.makerfaireorlando.com/makers-json/"
        let url: URL = URL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        session.configuration.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        
        

        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
        
            
            if (error != nil) {
                print("error:",error!)
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
                    // Save it
                    do {
                        try data!.write(to: filename)
                        print("wrote makers.json")
                    } catch {
                        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                        print("failed to write makers.json")
                    }
                } catch let error as NSError {
                    print("HTTP Error: \(error.localizedDescription)")
                    

                }
            }
        }
        
        task.resume()
    }
}
