//
//  NewsVC.swift
//  WAH Kiosk
//
//  Created by Bogdan on 10/26/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit
import CoreGraphics

class NewsVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imgPageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.onInitialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.onInitialize()
    }
    
    func onInitialize() {
        let scrollViewWidth:CGFloat = self.imageScrollView.frame.width
        let scrollViewHeight:CGFloat = self.imageScrollView.frame.height

        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "beddingSlide1.jpg")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "beddingSlide2.jpg")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth * 2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "beddingSlide3.jpg")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth * 3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "beddingSlide4.jpg")
        
        self.imageScrollView.addSubview(imgOne)
        self.imageScrollView.addSubview(imgTwo)
        self.imageScrollView.addSubview(imgThree)
        self.imageScrollView.addSubview(imgFour)
        
        self.imageScrollView.contentSize = CGSize(width:self.imageScrollView.frame.width * 4, height:self.imageScrollView.frame.height)
        self.imageScrollView.delegate = self
        self.imgPageControl.currentPage = 0
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(NewsVC.moveToNextPage), userInfo: nil, repeats: true)
    }
    
    func moveToNextPage() {
        let pageWidth:CGFloat = self.imageScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.imageScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.imageScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.imageScrollView.frame.height), animated: true)
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        print(currentPage)
        // Change the indicator
        self.imgPageControl.currentPage = Int(currentPage);
    }

}
