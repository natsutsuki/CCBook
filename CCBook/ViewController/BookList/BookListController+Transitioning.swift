//
//  BookListController+Transitioning.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

extension BookListController: IPhotoPresentingController
{
    func ubmPhotoGallery(numberOfImages galleryId: String) -> Int {
        return data.count
    }
    
    func ubmPhotoGallery(image forIndex: Int, in galleryId: String) -> (image: UIImage?, url: URL?) {
        let thisJob = data[forIndex]
        
        var imageURL: URL
        if thisJob.partInfo.isCustomImage {
            imageURL = URL.init(string: "https://api.u-bm.com/" + thisJob.customImages.first!)!
        } else {
            imageURL = URL.init(string: "https://api.u-bm.com/" + thisJob.storeImages.first!)!
        }
        
        if let image = ImageRemoteResource.getImage(url: imageURL) {
            return (image: image, url: imageURL);
        }
        
        return (image: nil, url: imageURL);
    }
    
    func ubmPhotoGalleryPresenting(viewFrame forIndex: Int, in galleryId: String) -> CGRect {
        
        let indexPath = IndexPath.init(item: forIndex, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)!
        
        let frameInWindow = cell.convert(cell.bounds, to: nil)
        return frameInWindow
    }
    
    func ubmPhotoGallery(snapView forIndex: Int, in galleryId: String) -> UIImageView {
        let indexPath = IndexPath.init(item: forIndex, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)! as! BookItemCell
        
        let frameInWindow = cell.convert(cell.bounds, to: nil)
        
        let snapshotImageView = UIImageView(frame: frameInWindow)
        snapshotImageView.clipsToBounds = true
        snapshotImageView.contentMode = .scaleAspectFit
        snapshotImageView.image = cell.imageView.image
        
        return snapshotImageView;
    }
    
}
