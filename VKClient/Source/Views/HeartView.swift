//
//  HeartView.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 24.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class HeartView: UIControl {

}

//extension UIBezierPath  {
//
//    func getHearts(originalRect: CGRect, scale: Double) -> UIBezierPath {
//
//        //Scaling will take bounds from the originalRect passed
//        let scaledWidth = (originalRect.size.width * CGFloat(scale))
//        let scaledXValue = ((originalRect.size.width) - scaledWidth) / 2
//        let scaledHeight = (originalRect.size.height * CGFloat(scale))
//        let scaledYValue = ((originalRect.size.height) - scaledHeight) / 2
//
//        let scaledRect = CGRect(x: scaledXValue, y: scaledYValue, width: scaledWidth, height: scaledHeight)
//        self.move(to: CGPoint(x: originalRect.size.width/2, y: scaledRect.origin.y + scaledRect.size.height))
//
//        self.addCurve(to: CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y + (scaledRect.size.height/4)),
//                      controlPoint1:CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2), y: scaledRect.origin.y + (scaledRect.size.height*3/4)) ,
//                      controlPoint2: CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y + (scaledRect.size.height/2)) )
//
//
//        self.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width/4),y: scaledRect.origin.y + (scaledRect.size.height/4)),
//                    radius: (scaledRect.size.width/4),
//                    startAngle: CGFloat(Double.pi),
//                    endAngle: 0,
//                    clockwise: true)
//
//        self.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width * 3/4),y: scaledRect.origin.y + (scaledRect.size.height/4)),
//                    radius: (scaledRect.size.width/4),
//                    startAngle: CGFloat(Double.pi),
//                    endAngle: 0,
//                    clockwise: true)
//
//        self.addCurve(to: CGPoint(x: originalRect.size.width/2, y: scaledRect.origin.y + scaledRect.size.height),
//                      controlPoint1: CGPoint(x: scaledRect.origin.x + scaledRect.size.width, y: scaledRect.origin.y + (scaledRect.size.height/2)),
//                      controlPoint2: CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2), y: scaledRect.origin.y + (scaledRect.size.height*3/4)) )
//
//        self.close()
//
//        return self
//    }
//}
