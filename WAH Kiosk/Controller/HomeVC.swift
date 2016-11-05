//
//  HomeVC.swift
//  WAH Kiosk
//
//  Created by Bogdan on 11/4/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailViewConstraint: NSLayoutConstraint!
    
    //Subview...
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var beddingTopBtnView: UIView!
    @IBOutlet weak var bathTopBtnView: UIView!
    @IBOutlet weak var housewareTopBtnView: UIView!
    
        
    
    let categoryArray = ["MATTRESS", "BEDDING", "BATH", "HOUSEWARES", "SPECIALS"]
    let categoryImgArray = ["mattress.png", "bed.png", "bath.png", "houseware.png", "special.png"]
    
    let subImgArray = ["mattress.png", "bed.png", "bath.png", "houseware.png", "special.png"]
    let subTitleArray = ["MATTRESS", "BEDDING", "BATH", "HOUSEWARES", "SPECIALS"]
    let subPriceArray = ["$56", "$345", "$983", "$234", "$234"]
    
    let mainCellIdentifier = "mainCVC"
    let subCellIdentifier = "subCVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Main CollectionView Settings...
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        //Sub CollectionView Settings...
        subCollectionView.dataSource = self
        subCollectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onInitialize()
    }
    
    func onInitialize() {
        beddingTopBtnView.isHidden = true
        bathTopBtnView.isHidden = true
        housewareTopBtnView.isHidden = true
    }
    
    //MARK: - UICollectionView DataSource Methods...
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellIdentifier, for: indexPath) as! HomeCVC
            
            let img = UIImage(named: categoryImgArray[indexPath.row]) as UIImage?
            
            
            cell.categoryImgView.image = img
            cell.categoryName.text = categoryArray[indexPath.row]
            
            return cell
        } else if collectionView == subCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subCellIdentifier, for: indexPath) as! SubCVC
            
            let img = UIImage(named: subImgArray[indexPath.row]) as UIImage?
            
            cell.subImageView.image = img
            cell.titleLbl.text = subTitleArray[indexPath.row]
            cell.priceLbl.text = subPriceArray[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    //MARK: Category Button Actions...
    
    func onShowMainView() {
        mainViewConstraint.constant = 1765
        categoryViewConstraint.constant = 0
        detailViewConstraint.constant = 0
    }
    
    func onShowCategoryView() {
        mainViewConstraint.constant = 0
        categoryViewConstraint.constant = 850
        detailViewConstraint.constant = 0
    }
    
    func onShowDetailView() {
        mainViewConstraint.constant = 0
        categoryViewConstraint.constant = 0
        detailViewConstraint.constant = 800
    }
    
    //MARK: Home Button Action...
    
    @IBAction func onHomeBtnAction(_ sender: UIButton) {
        onShowMainView()
    }
    
    //MARK: Top Category Button Actions...
    
    @IBAction func onTopBtnAction(_ sender: UIButton) {
        onInitialize()
        
        switch sender.tag {
        case 2:
            onShowCategoryView()
        case 3:
            beddingTopBtnView.isHidden = false
        case 4:
            bathTopBtnView.isHidden = false
        case 5:
            housewareTopBtnView.isHidden = false
        case 6:
            onShowCategoryView()
        case 11:
            beddingTopBtnView.isHidden = true
        case 12:
            beddingTopBtnView.isHidden = true
        case 13:
            bathTopBtnView.isHidden = true
        case 14:
            bathTopBtnView.isHidden = true
        case 15:
            housewareTopBtnView.isHidden = true
        case 16:
            housewareTopBtnView.isHidden = true
        case 17:
            housewareTopBtnView.isHidden = true
        case 18:
            housewareTopBtnView.isHidden = true
        default:
            break
        }
        
        onShowCategoryView()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
