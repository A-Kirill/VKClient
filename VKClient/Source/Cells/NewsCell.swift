//
//  NewsCell.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 29.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    var count = 0
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var viewCounter: UILabel!
    
    @IBAction func presButton(_ sender: UIButton) {
        
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
                UIView.transition(with: counterLabel,
                                    duration: 0.6,
                                    options: .transitionFlipFromBottom,
                                    animations: { self.counterLabel.text = String(self.count) })
            } else {
                UIView.transition(with: counterLabel,
                                    duration: 0.6,
                                    options: .transitionFlipFromBottom,
                                    animations: { self.counterLabel.text = String(self.count + 1) })
            }
    }
    
    override func awakeFromNib() {
        counterLabel.text = String(count)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        avaImage.image = nil
        nameLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.text = nil
        newsImage.image = nil
        counterLabel.text = nil
    }
    
}
