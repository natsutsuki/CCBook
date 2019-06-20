//
//  BookItemCell.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

class BookItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var irid: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 3
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.41
        layer.shadowOffset = CGSize(width: 2, height: 8)
        layer.shadowRadius = 5
        
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 5, dy: 0), cornerRadius: 10).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
            
        }
    }

}
