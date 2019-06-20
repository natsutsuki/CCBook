//
//  PhotoGalleryCell.swift
//  ubmPhotoClone
//
//  Created by c.c on 2019/6/19.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell, UIScrollViewDelegate
{

    private var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    var spiner:UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spiner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        spiner.hidesWhenStopped = true
        spiner.translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        
        scrollView = UIScrollView(frame: frame)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(spiner)
        spiner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spiner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        scrollView.addSubview(imageView)
        
        /* setup GestureRecognizer */
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(image:UIImage?,url:URL?) {
        if let image = image {
            spiner.stopAnimating()
            setImageView(image: image)
        } else if let url = url {
            ImageRemoteResource.getImage(url: url) { [weak self] (fetchImage) in
                self?.spiner.stopAnimating()
                self?.setImageView(image: fetchImage)
            }
        }
        else {
            spiner.startAnimating()
        }
    }
    
    func setImageView(image: UIImage) {
        let shrinkedFrame = image.boundsAspectFit(in: contentView.bounds)

        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 0, y: 0, width: shrinkedFrame.size.width, height: shrinkedFrame.size.height)
        
        scrollView.contentSize = imageView.bounds.size
        
        scrollView.maximumZoomScale = 3
        scrollViewDidZoom(scrollView)
    }
    
    @objc public func doubleTapAction(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
   
    // MARK: UIScrollViewDelegate Methods
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        }
        
    }

}
