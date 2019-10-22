//
//  CustomNavigationController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 09.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinished = false
}

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    let pushAnimator = PushTransitionAnimator()
    let popAnimator = PopTransitionAnimator()
    
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let edgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGestureCathed(_ :)))
        edgePanGR.edges = .left
        view.addGestureRecognizer(edgePanGR)
    }
    
    //MARK: - CustomNavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return pushAnimator
        case .pop:
            return popAnimator
        default:
            fatalError()
        }        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    @objc func edgePanGestureCathed(_ recognizer: UIScreenEdgePanGestureRecognizer){
        switch recognizer.state {
            
        case .began:
            interactiveTransition.hasStarted = true
            self.popViewController(animated: true)
            
        case .changed:
            guard let width = recognizer.view?.bounds.width else {
               interactiveTransition.hasStarted = false
                interactiveTransition.cancel()
                return
            }
            
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / width
            let progress = max(0, min(1, relativeTranslation))
            
            interactiveTransition.shouldFinished = progress > 0.4
            interactiveTransition.update(progress)
            
        case .ended:
            interactiveTransition.hasStarted = false
            interactiveTransition.shouldFinished ? interactiveTransition.finish() : interactiveTransition.cancel()
            
        case .cancelled:
            interactiveTransition.hasStarted = false
            interactiveTransition.cancel()
            
        default:
            break
        }
    }
}
