//
//  FirstViewController.swift
//  Orlando Maker Faire
//
//  Created by Conner Brooks on 6/8/14.
//  Copyright (c) 2014 Conner Brooks. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
                            
    @IBOutlet var mapView : UIImageView!
    @IBOutlet var scrollView : UIScrollView!
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { print(error!) ; return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            let status = (response as! HTTPURLResponse).statusCode
            print(status)
            if status == 200 {
                DispatchQueue.main.async() {
                    self.mapView.image = UIImage(data: data)
                    //self.setInitialZoom()
                }
            }
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
            let url = URL(string: filename.absoluteString)
            let data = try? Data(contentsOf: url!)
            //print("Loaded cached image")
            return UIImage(data: data!)!
        } else {
            print("no cached image for: ", filename.path)
        }
        
        
        let url = URL(string: link!)
        let data = try? Data(contentsOf: url!)
        
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
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.image = getImage(link:"https://jonadair.com/omf/map.png")
        
        /*
        if let url = URL(string: "https://jonadair.com/omf/map.png") {
            mapView.contentMode = .scaleAspectFit
            print("downloading")
            downloadImage(from: url)
        }
 */
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func setInitialZoom() {
        if mapView?.image != nil {
            // Initial zoom should fit the entire image on the screen
            scrollView.zoomScale = min(scrollView.frame.size.width / (mapView.image?.size.width)!, scrollView.frame.size.height / (mapView.image?.size.height)!)
            // That's also the most zoomed-out we want to allow
            scrollView.minimumZoomScale = scrollView.zoomScale
            
            print("initial zoom: ".appendingFormat("%f", scrollView.zoomScale))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialZoom()
    }
    
    @objc func doubleTapped() {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.zoomScale * 3
        } else {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
        
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

