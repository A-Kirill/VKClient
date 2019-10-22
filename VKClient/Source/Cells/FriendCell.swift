//
//  FriendCell.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView! {
        
        didSet {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapImage(recognizer:)))
            friendImageView.addGestureRecognizer(tapGR)
            friendImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        friendImageView.layer.cornerRadius = friendImageView.frame.size.width / 2
        friendImageView.layer.masksToBounds = true
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = CGSize.zero
    }
    
    
        @objc func tapImage(recognizer: UITapGestureRecognizer) {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = 1
            animation.toValue = 0.9
            animation.stiffness = 100
            animation.mass = 1
            animation.duration = 1
            animation.fillMode = CAMediaTimingFillMode.backwards
            
            self.friendImageView.layer.add(animation, forKey: nil)

        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        friendNameLabel.text = nil
        friendImageView.image = nil
    }
}
