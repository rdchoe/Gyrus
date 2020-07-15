//
//  CenterSheetPresentationController.swift
//  Gyrus
//
//  Created by Robert Choe on 6/30/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class CenterSheetPresentationController: UIPresentationController {
    
    public var cornerRadius: CGFloat = 20
    
    public var roundedCorners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: self.containerView!.frame.width / 20, y: (self.containerView!.frame.height)/5), size: CGSize(width: (self.containerView!.frame.width * 9)/10, height: (self.containerView!.frame.height * 3)/5))
    }
    
    
    /// Private Attributes
    
    private lazy var transparentOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addGestureRecognizer(self.tapGestureRecognizer)
        return view
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
    public convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, cornerRadius: CGFloat = 10) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.cornerRadius = cornerRadius
    }
    
    /// The presented view controller is being dismissed?
    override func dismissalTransitionWillBegin() {
        // Animate the blur view away
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {(UIViewControllerTransitionCoordinatorContext) in self.transparentOverlayView.alpha = 0}, completion: {(UIViewControllerTransitionCoordinatorContext) in self.transparentOverlayView.removeFromSuperview()})
    }
    
    override func presentationTransitionWillBegin() {
        self.transparentOverlayView.alpha = 0
        guard let presenterView = self.containerView else { return }
        presenterView.addSubview(self.transparentOverlayView)
        // Animate the the blur view
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.transparentOverlayView.alpha = 0.7
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
        self.transparentOverlayView.frame = presenterView.bounds
    }
    
    @objc private func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func drag(_ gesture: UIPanGestureRecognizer) {
       // YET TO BE IMPLEMENTED - should be able to dismiss bottom sheet on drag
    }
}
