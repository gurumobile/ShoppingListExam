//
//  HomeVC.swift
//  WAH Kiosk
//
//  Created by Bogdan on 10/26/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var mattMainView: UIView!
    @IBOutlet weak var mattSubView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.alpha = 0.0
        self.onInitialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Center Button Radius...
        mattMainView.layer.cornerRadius = mattMainView.frame.size.width / 2
        mattSubView.layer.cornerRadius = mattSubView.frame.size.width / 2
        mattMainView.layer.borderWidth = 24.0
        mattMainView.layer.borderColor = UIColor.white.cgColor
        
        mainView.alpha = 1.0
    }
    
    //MARK: - Initialize...
    func onInitialize() {
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height

        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "beddingSlide1.jpg")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "beddingSlide2.jpg")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "beddingSlide3.jpg")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "beddingSlide4.jpg")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    func moveToNextPage (){
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
    }
    
    //MARK: - Category Actions...
    @IBAction func onBeddingBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBathBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func onHousewareBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func onSpecialBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func onMattressBtn(_ sender: AnyObject) {
        
    }
    
    
    
    
    
    
    
    
}
