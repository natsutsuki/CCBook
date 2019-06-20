//
//  PhotoGalleryPresenting+Animated.swift
//  UbmPhotoGallery
//
//  Created by c.c on 2019/6/19.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

extension PhotoGalleryPresenting: UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let container = transitionContext.containerView
        
        container.subviews.forEach{ $0.removeFromSuperview() }
        
        /* 加入白色遮罩层 */
        container.addSubview(blockView)
        
        visualView_white.frame = container.bounds
        visualView_white.backgroundColor = UIColor.white
        visualView_white.alpha = 0
        container.addSubview(visualView_white)
        
        /* 加入动画用snapshotView */
        container.addSubview(snapshotView)
        
        /* 加入toView */
        toView.isHidden = true
        container.addSubview(toView)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.visualView_white.alpha = 1
            self.snapshotView.frame = finalFrame
            
        }) { (_) in
            toView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        if transitionCompleted {
            self.blockView.removeFromSuperview()
            self.snapshotView.removeFromSuperview()
            self.visualView_white.removeFromSuperview()
        }
    }
    
}
