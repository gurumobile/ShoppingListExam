//
//  MainVC.swift
//  WAH Kiosk
//
//  Created by Bogdan on 10/28/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var imageSlideView: UIView!
    @IBOutlet weak var welcomeView: UIView!
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let categoryArray = ["MATTRESS", "BEDDING", "BATH", "HOUSEWARES", "SPECIALS"]
    let categoryImgArray = ["mattress.png", "bed.png", "bath.png", "houseware.png", "special.png"]
    
    let reuseIdentifier = "mainCell"
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Slide Setting...
        pageControl.addTarget(self, action: #selector(MainVC.didChangePageControlValue), for: .valueChanged)
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MainVC.imageSlideAction), userInfo: nil, repeats: true);
    }
    
    //MAKR: - PageControl Fire Method...
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    //MARK: - Image Slide Action...
    func imageSlideAction() {
        tutorialPageViewController?.scrollToNextViewController()
    }
    
    //MARK: - Main Category Actions in header...
    @IBAction func onHomeBtn(_ sender: AnyObject) {
    }
    
    @IBAction func onMattressBtn(_ sender: AnyObject) {
    }
    
    @IBAction func onBeddingBtn(_ sender: AnyObject) {
    }
    
    @IBAction func onBathBtn(_ sender: AnyObject) {
    }
    
    @IBAction func onHousewareBtn(_ sender: AnyObject) {
    }
    
    @IBAction func onSpecialsBtn(_ sender: AnyObject) {
    }
    
    //MARK: - UICollectionViewDataSource Methods...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCVC
        
        let img = UIImage(named: categoryImgArray[indexPath.row]) as UIImage?
        
        cell.categoryNameLbl.text = categoryArray[indexPath.row]
        cell.imageBtn.setBackgroundImage(img, for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - Leftbar Blue Actions...
    @IBAction func onLeftBarBlueCollection(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlueSheets(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBluePillows(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlueDuvet(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlueMattress(_ sender: AnyObject) {
        
    }
    
    //MARK: - Leftbar Black Actions...
    @IBAction func onLeftBarBlackCollection(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlackSheets(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlackPillows(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlackDuvet(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlackMattress(_ sender: AnyObject) {
        
    }
    
    //Collection Image Actions...
    @IBAction func onBlueCollectionImageBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func onBlackCollectionImageBtn(_ sender: AnyObject) {
        
    }
    
    //Shop Collection Actions...
    @IBAction func onShopBlueCollection(_ sender: AnyObject) {
        
    }
    
    @IBAction func onShopBlackCollection(_ sender: AnyObject) {
        
    }
    
    //MARK: - By Category...
    @IBAction func onCateMattress(_ sender: Any) {
    }
    
    @IBAction func onCateBedding(_ sender: Any) {
    }
    
    @IBAction func onCateBath(_ sender: Any) {
    }
    
    @IBAction func onCateHousewares(_ sender: Any) {
    }
    
    
    @IBAction func onCateSpecials(_ sender: Any) {
    }
    
    @IBAction func onCateBlueCollection(_ sender: Any) {
    }
    
    @IBAction func onCateBlackCollection(_ sender: Any) {
    }
}

extension MainVC: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
