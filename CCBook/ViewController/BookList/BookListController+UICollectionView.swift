//
//  BookListController+UICollectionView.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

extension BookListController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BookItemCell
        
        let thisJob = data[indexPath.item]
        cell.irid = thisJob.partInfo._id
        
        var imageURL: URL
        if thisJob.partInfo.isCustomImage {
            imageURL = URL.init(string: "https://api.u-bm.com/" + thisJob.customImages.first!)!
        } else {
            imageURL = URL.init(string: "https://api.u-bm.com/" + thisJob.storeImages.first!)!
        }
        
        ImageRemoteResource.getImage(url: imageURL) { (fetchedImage) in
            // 这个时候Cell可能被重用了，所以要检查下
            if cell.irid == thisJob.partInfo._id {
                cell.imageView.image = fetchedImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 转场
        /*
         let tgvc = DetailController.init()
         tgvc.transitioningDelegate = self
         tgvc.modalPresentationStyle = .custom
         
         present(tgvc, animated: true, completion: nil)
         */
        
        let tgvc = PhotoGalleryController(dataSource: self, activeIndex: indexPath.item, identifier: "ccBook")
        present(tgvc, animated: true, completion: nil)
    }
    
}
