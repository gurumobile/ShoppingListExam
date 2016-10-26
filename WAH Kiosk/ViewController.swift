//
//  ViewController.swift
//  WAH Kiosk
//
//  Created by Bogdan on 10/26/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LGProgressHUD.showHud(IndeficatorType: LGProgressIndeficatorType.custom, view: self.view)
    }

    //MARK: - Dismiss Hud...
    func dismiss() {
        LGProgressHUD.dismiss(self.view)
    }
}

