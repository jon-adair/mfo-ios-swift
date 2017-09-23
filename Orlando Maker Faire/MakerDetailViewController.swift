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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.maker?.project_name
        
        makerTitle.text = self.maker?.project_name
        makerDescription.text = self.maker?.maker_description
        makerLocation.text = self.maker?.location
        
        if self.maker?.location == "Unassigned" {
            makerLocation.text = ""
        }
        
        if ( maker?.photo_link != nil ) {
            
            let url = URL(string: (self.maker?.photo_link!)!)
            let data = try? Data(contentsOf: url!)
            if ( data != nil ) {
                self.makerPhoto.image = UIImage(data: data!)
            } else {
                makerPhoto.image = UIImage(named: "makey")
            }
        } else {
            makerPhoto.image = UIImage(named: "makey")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
