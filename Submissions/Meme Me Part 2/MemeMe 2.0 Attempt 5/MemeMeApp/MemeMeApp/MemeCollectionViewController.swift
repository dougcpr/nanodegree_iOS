//
//  MemeCollectionViewController.swift
//  MemeMeApp
//
//  Created by Douglas Cooper on 11/24/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes: [Meme]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
}
