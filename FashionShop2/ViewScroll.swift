//
//  ViewScroll.swift
//  FashionShop2
//
//  Created by techmaster on 1/17/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

import UIKit

class ViewScroll: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageImages: [String] = []
    var first = false
    var photo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageImages = ["shop1-0", "shop1-1", "shop1-2"]
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageImages.count
        
    }
    
    override func viewDidLayoutSubviews() {
        if !first {
            first = true
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: 0.0)
            for i in 0..<pageImages.count {
                let imgView = UIImageView(image: UIImage(named: pageImages[i] + ".jpg"))
                imgView.frame = CGRect(x: pagesScrollViewSize.width * CGFloat(i), y: 0, width: pagesScrollViewSize.width, height: pagesScrollViewSize.height)
                imgView.contentMode = .scaleAspectFit
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapImg(_:)))
                singleTap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(singleTap)
                
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg(_:)))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                singleTap.require(toFail: doubleTap)
                
                if i == 0 {
                    photo = imgView
                }
                
                scrollView.addSubview(imgView)
                scrollView.delegate = self
                scrollView.minimumZoomScale = 0.5
                scrollView.maximumZoomScale = 2.0
            }
        }
    }
    
    func singleTapImg(_ singleTapGesture: UITapGestureRecognizer) {
        let position = singleTapGesture.location(in: photo)
        zoomRectForScale(scale: scrollView.zoomScale * 2.0, center: position)
    }
    
    func doubleTapImg(_ doubleTapGesture: UITapGestureRecognizer) {
        let position = doubleTapGesture.location(in: photo)
        zoomRectForScale(scale: scrollView.zoomScale * 0.5, center: position)
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) {
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.width = scrollViewSize.width / scale
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fractionalPage = scrollView.contentOffset.x / scrollView.frame.size.width
        let page = lround(Double(fractionalPage))
        pageControl.currentPage = page
    }

    @IBAction func onChange(_ sender: UIPageControl) {
        scrollView.contentOffset = CGPoint(x: CGFloat(pageControl.currentPage) * scrollView.frame.size.width, y: 0.0)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
    
}
