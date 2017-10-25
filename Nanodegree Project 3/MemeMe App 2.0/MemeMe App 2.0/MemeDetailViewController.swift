//
//  MemeDetailViewController.swift
//  MemeMe App 2.0
//
//  Created by Douglas Cooper on 11/3/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme: Meme!
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = selectedMeme.memedImage
        detailImageView.contentMode = .scaleAspectFit
        
        
    }
}
