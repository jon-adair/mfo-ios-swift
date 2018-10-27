//
//  MakerViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/9/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MakerAPIProtocol, UISearchBarDelegate {

    let kCellIdentifier: String = "MakerCell"
    
    var api: MakerAPI?
    
    @IBOutlet var makerTableView : UITableView!
    
    var makers: [Maker] = []
    
    var searchResults: [Maker] = []
    
    var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api = MakerAPI(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:50, height:50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating();
        self.view.addSubview(activityIndicator)

        
        self.api!.getMakers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) 
    
        
        let maker = self.makers[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = maker.project_name
        cell.detailTextLabel!.text = maker.organization

        /*
        var cellImg : UIImageView = UIImageView(frame: CGRect(x:0.0,y:0.0,width:40.0,height:40.0))
        
        // TODO: Too slow without caching
        if ( maker.photo_link != nil ) {
            let url = URL(string: maker.photo_link!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cellImg.image = UIImage(data: data!)
            //cell.imageView?.image = UIImage(data: data!)
        } else {
            cellImg.image = UIImage(named: "makey")
            //cell.imageView?.image = UIImage(named: "makey")
        }
        cellImg.image = UIImage(named: "yourimage.png")
        cell.addSubview(cellImg)
        //cell.imageView?.frame = CGRect(x:0.0,y:0.0,width:40.0,height:40.0)
        //cell.contentMode = UIViewContentMode.scaleAspectFit
        //cell.clipsToBounds = true
         */
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let detailViewController: MakerDetailViewController = segue.destination as! MakerDetailViewController
        let makerIndex = makerTableView.indexPathForSelectedRow!.row
        let selectedMaker = self.makers[makerIndex]
        detailViewController.maker = selectedMaker
        
    }
    
    func didReceiveAPIResults(_ results: NSDictionary) {
        
        let allResults: [NSDictionary] = results["accepteds"] as! [NSDictionary]
    
        for result:NSDictionary in allResults {
            let project_name: String? = result["project_name"] as? String
            let maker_description: String? = result["description"] as? String
            let web_site: String? = result["web_site"] as? String
            let organization: String? = result["organization"] as? String
            let project_short_summary: String? = result["project_short_summary"] as? String
            let photo_link: String? = result["photo_link"] as? String
            let location: String? = result["location"] as? String
            
            //var promo_url: String? = result["promo_url"] as? String
            //var qrcode_url: String? = result["qrcode_url"] as? String
            //var category: String? = result["category"] as? String
            //var photo_link: String? = result["photo_link"] as? String
            
            let newMaker = Maker(project_name: project_name, maker_description: maker_description, web_site: web_site, organization: organization, project_short_summary: project_short_summary, photo_link: photo_link, location: location)
            
            self.makers.append(newMaker)
        }
        // Need to do this on the main thread because this gets called by an asynch background thread
        DispatchQueue.main.async{
            self.activityIndicator.removeFromSuperview()
            self.makerTableView.reloadData()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
