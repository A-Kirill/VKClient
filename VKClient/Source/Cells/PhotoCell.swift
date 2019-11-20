//
//  PhotoCell.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    var count = 0
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var countLikeLabel: UILabel!
    
    @IBAction func likeButton(_ sender: UIButton) {
        
        let count = Int(self.countLikeLabel.text ?? "")
        
        // animate views and labels
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: .curveLinear,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)}) {(success) in
                            sender.isSelected = !sender.isSelected
                            UIView.animate(withDuration: 0.2,
                                           delay: 0.1,
                                           options: .curveLinear,
                                           animations: { sender.transform = .identity}, completion: nil)
        }
        
        if sender.isSelected {
            UIView.transition(with: countLikeLabel,
                              duration: 0.6,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.countLikeLabel.text = String(count! - 1)
            })
        } else {
            UIView.transition(with: countLikeLabel,
                              duration: 0.6,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.countLikeLabel.text = String(count! + 1)
            })
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
    }
    
    override func awakeFromNib() {
        countLikeLabel.text = String(count)
    }
    
}
