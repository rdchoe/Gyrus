//
//  GyrusTabBar.swift
//  Gyrus
//
//  Created by Robert Choe on 5/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

/**
 Custom UITabbar for Gyrus
 */
@IBDesignable
class GyrusTabBar: UITabBar {
    /// Implemented with the guide of this tutorial: https://medium.com/better-programming/draw-a-custom-ios-tabbar-shape-27d298a7f4fa
    
    /// The shape of the nav bar
    private var shapeLayer: CALayer?
    private var mainEventButton: UIButton = {
       let mainEventButton = UIButton()
        mainEventButton.frame.size = CGSize(width: 80, height: 80)
        mainEventButton.backgroundColor = Constants.colors.blue
        mainEventButton.layer.cornerRadius = mainEventButton.frame.width / 2
        mainEventButton.layer.masksToBounds = true

        // adding drop shadow
        mainEventButton.layer.shadowColor = UIColor.black.cgColor
        mainEventButton.layer.shadowOpacity = 0.5
        mainEventButton.layer.shadowOffset = .zero
        mainEventButton.layer.shadowRadius = 10
        mainEventButton.layer.shouldRasterize = true
        mainEventButton.layer.rasterizationScale = UIScreen.main.scale

        return mainEventButton
    }()
    
    func setup() {
        self.addShape()
    }
    
    private func addShape()  {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = Constants.colors.gray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = Constants.tabbar.tabbarLineWidth
       
        // Replacing the current shape layer on the tab bar
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func createPathCircle() -> CGPath {
        
        let radius: CGFloat = Constants.tabbar.tabbarRadius
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        // Drawing out the path
        path.move(to: CGPoint(x: 0, y: 0)) // Top left
        path.addLine(to: CGPoint(x: centerWidth - radius , y: 0)) // start of circle
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0)) // Top Right
        return path.cgPath
    }
    
    private func setupMiddleButton() {
        print("i am here")
        //self.mainEventButton.center = CGPoint(x: self.frame.width / 2, y: 0)
        addSubview(self.mainEventButton)
    }
}
