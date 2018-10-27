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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let url = URL(string: "https://jonadair.com/omf/map.png") {
            mapView.contentMode = .scaleAspectFit
            print("downloading")
            downloadImage(from: url)
        }
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

