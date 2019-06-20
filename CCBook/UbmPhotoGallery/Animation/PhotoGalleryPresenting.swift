//
//  PhotoGalleryPresenting.swift
//  ubmPhotoClone
//
//  Created by c.c on 2019/6/14.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

/// 画廊入场动画
class PhotoGalleryPresenting: NSObject, UIViewControllerTransitioningDelegate
{
    var snapshotView: UIImageView!
    var visualView_white: UIView!
    var blockView: UIView!
    
    init(image snapshot: UIImageView) {
        self.snapshotView = snapshot
        self.visualView_white = UIView()
        self.blockView = UIView(frame: snapshotView.frame.insetBy(dx: -1, dy: -1))
        self.blockView.backgroundColor = UIColor.white
        
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self;
    }
    
}
