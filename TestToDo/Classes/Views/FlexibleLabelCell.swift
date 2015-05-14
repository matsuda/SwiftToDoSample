//
//  FlexibleLabelCell.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/05/08.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

class FlexibleLabelCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        contentLabel.preferredMaxLayoutWidth = contentLabel.frame.size.width
        super.layoutSubviews()
    }
}
