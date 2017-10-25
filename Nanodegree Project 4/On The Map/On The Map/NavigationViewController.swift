//
//  NavigationViewController.swift
//  On The Map
//
//  Created by Douglas Cooper on 4/24/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit

class navigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem?.title = "Logout"
    }
    
}
