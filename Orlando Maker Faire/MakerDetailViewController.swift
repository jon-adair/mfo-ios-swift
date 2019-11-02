//
//  MakerDetailViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 6/10/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit


class MakerDetailViewController : UIViewController {
    
    @IBOutlet var makerTitle : UILabel!
    @IBOutlet var makerDescription : UILabel!
    @IBOutlet var makerPhoto : UIImageView!
    @IBOutlet var makerLocation: UILabel!
    
    var maker:Maker?
    
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
            if data == nil || data?.count == 0 {
                return UIImage(named: "makey")!
            }
            return UIImage(data: data!)!
        } else {
            print("no cached image for: ", filename.path)
        }
        
        
        let url = URL(string: link!)
        let data = try? Data(contentsOf: url!)
        if data == nil || data?.count == 0 {
            return UIImage(named: "makey")!
        }

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
        self.title = self.maker?.project_name
        
        makerTitle.text = self.maker?.project_name
        makerDescription.text = self.maker?.maker_description
        makerLocation.text = self.maker?.location
        
        if self.maker?.location == "Unassigned" {
            makerLocation.text = ""
        }
        
        makerPhoto.image = getImage(link: self.maker?.photo_link!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
