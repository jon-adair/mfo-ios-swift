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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        // Initial zoom should fit the entire image on the screen
        scrollView.zoomScale = min(scrollView.frame.size.width / (mapView.image?.size.width)!, scrollView.frame.size.height / (mapView.image?.size.height)!)
        // That's also the most zoomed-out we want to allow
        scrollView.minimumZoomScale = scrollView.zoomScale
        
        print("initial zoom: ".appendingFormat("%f", scrollView.zoomScale))
        
    }
    
    func doubleTapped() {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.zoomScale * 2
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

