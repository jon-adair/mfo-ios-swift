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

class MakerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MakerAPIProtocol, UISearchBarDelegate {
    @IBOutlet weak var makerCollectionView: UICollectionView!
    let kCellIdentifier: String = "MakerCell"
    var api: MakerAPI?
    var makers: [Maker] = []
    var searchResults: [Maker] = []
    var activityIndicator: UIActivityIndicatorView!
    var makeyImage: UIImage?
    
    // MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = MakerAPI(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:50, y:10, width:50, height:50)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating();
        self.view.addSubview(activityIndicator)
        
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
        self.api!.getMakers(refresh:false)

        self.makerCollectionView.addSubview(self.refreshControl)
        
        let flowLayout = makerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = makerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    // MARK: CollectionView handling
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return makers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        
        let maker = self.makers[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = maker.project_name
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols: CGFloat = floor(collectionView.bounds.width / 200)
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width : CGFloat = floor((collectionView.bounds.width - flowLayout.minimumInteritemSpacing * (cols-1)) / cols)
        let height : CGFloat = floor(width * 3.0 / 4.0)
        return CGSize(width: width, height: height)
    }
    

    // MARK: Refresh
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
    
    // MARK: image caching
    
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
    
    // MARK: API results
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
    
    // MARK: image caching
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
}
