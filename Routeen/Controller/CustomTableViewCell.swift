//
//  CustomTableViewCell.swift
//  Routeen
//
//  Created by Nils Backe on 6/14/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var taskName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
