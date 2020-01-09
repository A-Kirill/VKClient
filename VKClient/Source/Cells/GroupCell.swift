//
//  GroupCell.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    override func awakeFromNib() {
        groupImageView.layer.cornerRadius = groupImageView.frame.size.width / 2
        groupImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        
            nameLabel.text = nil
            groupImageView.image = nil
    }
}
