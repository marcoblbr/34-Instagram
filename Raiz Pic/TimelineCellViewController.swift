//
//  TimelineCellViewController.swift
//  Raiz Pic
//
//  Created by Marco on 8/18/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit

class TimelineCellViewController: UITableViewCell {

    @IBOutlet weak var imagePosted: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
