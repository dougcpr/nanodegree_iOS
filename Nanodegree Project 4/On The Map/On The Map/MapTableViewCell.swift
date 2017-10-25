//
//  MapTableViewCell.swift
//  On The Map
//
//  Created by Douglas Cooper on 4/25/17.
//  Copyright © 2017 Douglas Cooper. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
