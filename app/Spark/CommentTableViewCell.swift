//
//  CommentTableViewCell.swift
//  SparkMap
//
//  Created by Edvard Holst on 16/05/16.
//  Copyright © 2016 Zygote Labs. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var commentTextLabel: UILabel?
    @IBOutlet var commentUsernameLabel: UILabel?
    @IBOutlet var commentDateLabel: UILabel?
    @IBOutlet var commentRatingView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
