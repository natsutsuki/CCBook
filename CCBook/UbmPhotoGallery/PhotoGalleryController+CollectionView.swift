//
//  PhotoGalleryController+CollectionView.swift
//  ubmPhotoClone
//
//  Created by c.c on 2019/6/19.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit
import Photos

extension PhotoGalleryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.ubmPhotoGallery(numberOfImages: galleryIdentifier);
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoGalleryCell
        
        let (image,url) = dataSource.ubmPhotoGallery(image: indexPath.row, in: galleryIdentifier)
        cell.config(image: image, url: url)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard
            let indexPath = collectionView.indexPathsForVisibleItems.last,
            let layoutAttributes = flowLayout.layoutAttributesForItem(at: indexPath)
            else {
                return proposedContentOffset
        }
        
        return CGPoint(x: layoutAttributes.center.x - (layoutAttributes.size.width / 2.0) - (flowLayout.minimumLineSpacing / 2.0), y: 0)
    }
    
}
