//
//  BottomSheetPresentationController.swift
//  Gyrus
//  Referencing https://github.com/Que20/UIDrawer by Kevin Maarek
//  Created by Robert Choe on 6/12/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit
class BottomSheetPresentationController: UIPresentationController {
    public var blurEffectStyle: UIBlurEffect.Style = .light
    
    public var topGap: CGFloat = 88
    
    public var modalWidth: CGFloat = 0
    
    public var cornerRadius: CGFloat = 20
    
    public var roundedCorners: UIRectCorner = [.topLeft, .topRight]
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: (self.containerView!.frame.height * 3)/5), size: CGSize(width: self.modalWidth == 0 ? self.containerView!.frame.width : self.modalWidth, height: (self.containerView!.frame.height * 2)/5))
    }
    
    
    /// Private Attributes
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
        blur.isUserInteractionEnabled = true
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.addGestureRecognizer(self.tapGestureRecognizer)
        return blur
    }()
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.drag(_:)))
        return pan
    }()
    
    
    /// Initializers
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /// Convience intit
    public convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, blurEffectStyle: UIBlurEffect.Style = .light, topGap: CGFloat = 88, modalWidth: CGFloat = 0, cornerRadius: CGFloat = 20) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.blurEffectStyle = blurEffectStyle
        self.topGap = topGap
        self.modalWidth = modalWidth
        self.cornerRadius = cornerRadius
    }
    
    /// The presented view controller is being dismissed?
    override func dismissalTransitionWillBegin() {
        // Animate the blur view away
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {(UIViewControllerTransitionCoordinatorContext) in self.blurEffectView.alpha = 0}, completion: {(UIViewControllerTransitionCoordinatorContext) in self.blurEffectView.removeFromSuperview()})
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        guard let presenterView = self.containerView else { return }
        presenterView.addSubview(self.blurEffectView)
        // Animate the the blur view
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let presentedView = self.presentedView else { return }
        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: self.roundedCorners, radius: self.cornerRadius)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presenterView = self.containerView else { return }
        guard let presentedView = self.presentedView else { return }
        
        presentedView.frame = self.frameOfPresentedViewInContainerView
        // I think this is for iPAD; try using without?
        presentedView.frame.origin.x = (presenterView.frame.width - presentedView.frame.width) / 2
        //presentedView.center = CGPoint(x: presentedView.center.x, y: presenterView.center.y * 2)
        // setting the blur effect frame behind the modal
        self.blurEffectView.frame = presenterView.bounds
    }
    
    @objc private func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func drag(_ gesture: UIPanGestureRecognizer) {
       // YET TO BE IMPLEMENTED - should be able to dismiss bottom sheet on drag
    }
}
