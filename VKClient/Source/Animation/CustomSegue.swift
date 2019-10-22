//
//  CustomSegue.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 09.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    let duration: TimeInterval = 2
    
    override func perform() {
        guard let containerView = source.view else {return}
        containerView.addSubview(destination.view)
        source.view.frame = containerView.frame
        destination.view.frame = containerView.frame
        
        //transform view on needed position = source view position
        destination.view.transform = CGAffineTransform(translationX: source.view.bounds.width, y: source.view.bounds.height)
       
        //animation
        UIView.animate(withDuration: duration, animations: {
            self.destination.view.transform = .identity
        }, completion: { _ in
            self.source.present(self.destination, animated: false)
        })
    }

}
