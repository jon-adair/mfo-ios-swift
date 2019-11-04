//
//  MakerViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/9/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit
import CoreData

class MyCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var makerImage: UIImageView!
}


class MakerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MakerAPIProtocol, UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Got count")
        //return 5
         return makers.count
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(EventViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refresh")
        self.api?.getMakers(refresh:true)
        refreshControl.endRefreshing()
    }
    
    func getImageAsync(link: String, completion: @escaping (_ image: UIImage?) -> Void) -> URLSessionDataTask? {
        if let imageURL = URL(string: link) {
            return URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let data = data {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }
        } else {
            return nil
        }
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
            // in other words, once we have an image, cache it forever
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        
        let maker = self.makers[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = maker.project_name
        
        /*
        // TODO: Too slow without caching
        if ( maker.photo_link != nil ) {
            let url = URL(string: maker.photo_link!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.makerImage.image = UIImage(data: data!)
            //cell.imageView?.image = UIImage(data: data!)
        } else {
            cell.makerImage.image = UIImage(named: "makey")
            //cell.imageView?.image = UIImage(named: "makey")
        }
        */
        
        //        cell.makerImage.image = getImage(link: maker.photo_link)
        
        // clumsy lazy-load instead
        cell.makerImage.image = UIImage(named: "makey-blurred")
        cell.tag = indexPath.row
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let image = self.getImage(link: maker.photo_link)
            
            DispatchQueue.main.async{
                if(cell.tag == indexPath.row) {
                    cell.makerImage.image = image
                }
            }
        }
        
        //cell.textLabel?.text = String(indexPath.row + 1)
        //print("Got cell \(indexPath.row)")
        //cell.backgroundColor = UIColor.red
        return cell
        
    }
    
    

    let kCellIdentifier: String = "MakerCell"
    
    var api: MakerAPI?
    
    @IBOutlet var makerTableView : UITableView!
    
    @IBOutlet weak var makerCollectionView: UICollectionView!
    
    var makers: [Maker] = []
    
    var searchResults: [Maker] = []
    
    var activityIndicator: UIActivityIndicatorView!

    var makeyImage: UIImage?
    
    override func viewDidLoad() {
        print("View did load")
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
        
        // Register cell classes
       // self.makerCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
  
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Thumbnail", in: context)
        let newThumbnail = NSManagedObject(entity: entity!, insertInto: context)
        
        let makey = UIImage(named: "makey.png")
        newThumbnail.setValue("makey", forKey: "tag")
        newThumbnail.setValue(makey?.pngData(), forKey: "image")
        do {
            try context.save()
            print("saved")
        } catch {
            print("Failed saving")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Thumbnail")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "tag") as! String)
                let image: Data = data.value(forKey: "image")! as! Data
                let decodedimage = UIImage(data: image)
                makeyImage = decodedimage
                print("Got an image")
            }
        } catch {
            print("Failed")
        }

        self.makerCollectionView.addSubview(self.refreshControl)

        
        self.api!.getMakers(refresh:false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makers.count
    }
    

    func uncacheImage(tag: String) -> UIImage? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Thumbnail")
        request.predicate = NSPredicate(format: "tag == %@", tag)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "tag") as! String)
                let image: Data = data.value(forKey: "image")! as! Data
                let decodedimage = UIImage(data: image)
                print("Got an image")
                return decodedimage
            }
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) 
    
        
        let maker = self.makers[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = maker.project_name
        //cell.detailTextLabel!.text = maker.organization

        
        let cellImg : UIImageView = UIImageView(frame: CGRect(x:0.0,y:0.0,width:40.0,height:40.0))
        
        // TODO: Too slow without caching
        if ( maker.photo_link != nil ) {
            let url = URL(string: maker.photo_link!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cellImg.image = UIImage(data: data!)
            //cell.imageView?.image = UIImage(data: data!)
        } else {
            //cellImg.image = UIImage(named: "makey")
            cellImg.image = makeyImage
            //cell.imageView?.image = UIImage(named: "makey")
        }
        //cellImg.image = UIImage(named: "yourimage.png")
        cell.addSubview(cellImg)
        //cell.imageView?.frame = CGRect(x:0.0,y:0.0,width:40.0,height:40.0)
        //cell.contentMode = UIViewContentMode.scaleAspectFit
        //cell.clipsToBounds = true
 
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let detailViewController: MakerDetailViewController = segue.destination as! MakerDetailViewController
        //let makerIndex = makerTableView.indexPathForSelectedRow!.row
        let selected = makerCollectionView.indexPathsForSelectedItems
        print("Selected: \(selected!.count)")
        
        let makerIndex = selected?[0].row
        

        let selectedMaker = self.makers[makerIndex!]
        detailViewController.maker = selectedMaker
        
    }
    
    func didReceiveAPIResults(_ results: NSDictionary) {
        makers = []

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
            self.makerCollectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            // Now start crawling images and caching them if we don't already have them
            for maker in self.makers {
                _ = self.getImage(link: maker.photo_link)
            }
        }
    }
}
