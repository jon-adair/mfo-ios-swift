//
//  MakerDetailTableViewController.swift
//  Maker Faire Orlando
//
//  Created by Conner Brooks on 8/30/15.
//  Copyright (c) 2015 Conner Brooks. All rights reserved.
//

import UIKit


class MakerDetailTableViewController : UITableViewController {
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectLocation: UILabel!
    @IBOutlet weak var projectDescription: UILabel!
    @IBOutlet weak var makerName: UILabel!
    @IBOutlet weak var makerDescription: UILabel!
    
    var project:Project?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = self.maker?.project_name
        
        // project
        projectName.text = self.project?.project_name
        projectLocation.text = self.project?.location
        print(self.project?.location)
        projectDescription.text = self.project?.description
        
        // maker
        makerName.text = self.project?.maker?.name
        makerDescription.text = self.project?.maker?.description
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}