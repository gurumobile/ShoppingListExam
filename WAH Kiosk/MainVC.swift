//
//  MainVC.swift
//  WAH Kiosk
//
//  Created by Bogdan on 10/26/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var roundImageView: UIImageView!
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
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
        
        self.onTabbarInit()
    }
    
    //MARK: - Button Initialize...
    
    func onTabbarInit() {
        let origImage = UIImage(named: "round.png");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.roundImageView.image = tintedImage
        self.roundImageView.tintColor = UIColor.red
        
        self.newsView.backgroundColor = UIColor.red
        self.discountView.backgroundColor = UIColor.red
        self.homeView.backgroundColor = UIColor.red
        self.wishlistView.backgroundColor = UIColor.red
        self.settingsView.backgroundColor = UIColor.red
    }
    
    //MARK: - Button Methods...
    
    @IBAction func onNewsBtn(_ sender: AnyObject) {
        self.onTabbarInit()
        
        self.newsView.backgroundColor = UIColor(hexString: "CC0000", alpha: 0.6)
    }
    
    @IBAction func onDiscountBtn(_ sender: AnyObject) {
        self.onTabbarInit()
        
        self.discountView.backgroundColor = UIColor(hexString: "CC0000", alpha: 0.6)
    }
    
    @IBAction func onHomeBtn(_ sender: AnyObject) {
        self.onTabbarInit()
        
        self.roundImageView.tintColor = UIColor(hexString: "CC0000", alpha: 0.6)
        self.homeView.backgroundColor = UIColor(hexString: "CC0000", alpha: 0.6)
    }

    @IBAction func onSettingsBtn(_ sender: AnyObject) {
        self.onTabbarInit()
        
        self.settingsView.backgroundColor = UIColor(hexString: "CC0000", alpha: 0.6)
    }
    
    @IBAction func onWishlistBtn(_ sender: AnyObject) {
        self.onTabbarInit()
        
        self.wishlistView.backgroundColor = UIColor(hexString: "CC0000", alpha: 0.6)
    }
}
