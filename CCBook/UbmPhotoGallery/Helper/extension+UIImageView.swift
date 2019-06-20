//
//  extension+UIImageView.swift
//  ubmPhotoClone
//
//  Created by c.c on 2019/6/15.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        return image.boundsAspectFit(in: bounds);
    }
}

extension UIImage
{
    /// image按比例放入bounds,应该所在的位置
    func boundsAspectFit(in rect: CGRect) -> CGRect
    {
        // Calculate resize ratios for resizing
        let ratioW = rect.width / size.width;
        let ratioH = rect.height / size.height;
        
        // smaller ratio will ensure that the image fits in the view
        let ratio:CGFloat = ratioW < ratioH ? ratioW:ratioH;
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let x = (rect.width - newSize.width) / 2.0
        let y = (rect.height - newSize.height) / 2.0
        
        return CGRect(x: x, y: y, width: newSize.width, height: newSize.height)
    }
    
}
