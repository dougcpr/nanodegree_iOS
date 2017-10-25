//
//  Meme.swift
//  MemeMe 2.0
//
//  Created by Douglas Cooper on 11/1/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import Foundation
import UIKit
class Meme{
    var topText:String!
    var bottomText:String!
    var image: UIImage! //Original Image
    var memedImage: UIImage! //The generated image with Top and bottom text.

    init(topText:String,bottomText:String, image:UIImage, memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}
