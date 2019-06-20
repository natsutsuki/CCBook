//
//  BookListController.swift
//  ubmAppleBookClone
//
//  Created by c.c on 2019/6/13.
//  Copyright © 2019 c.c. All rights reserved.
//

import UIKit

class BookListController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var data:Array<InfoReleaseDetailDtoOutput> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 
        collectionView.register(UINib.init(nibName: "BookItemCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
        collectionView.register(UINib.init(nibName: "BookItemSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        WebService.shared.fetchData { [weak self] (jobs) in
            guard let weakSelf = self else { return }
            
            weakSelf.data = jobs
            weakSelf.collectionView.reloadData()
        }
    }
    
}
