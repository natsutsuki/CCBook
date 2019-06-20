//
//  IPhotoPresentingController.swift
//  ubmPhotoClone
//
//  Created by c.c on 2019/6/15.
//  Copyright © 2019 c.c. All rights reserved.
//

import Foundation
import UIKit

/// 弹出层协议
public protocol IPhotoPresentingController:class
{
    /// 图片总数量
    func ubmPhotoGallery(numberOfImages galleryId:String) -> Int
    
    /// 每张图片的资源
    func ubmPhotoGallery(image forIndex:Int, in galleryId: String) -> (image:UIImage?,url:URL?)
    
    /// 触发画廊的view的frame，对应在window的下位置(动画转场用)
    func ubmPhotoGalleryPresenting(viewFrame forIndex:Int, in galleryId: String) -> CGRect
    
    /// 触发画廊的view的快照，用于动画转场
    func ubmPhotoGallery(snapView forIndex:Int, in galleryId: String) -> UIImageView
}
