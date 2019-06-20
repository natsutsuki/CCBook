//
//  PhotoGalleryController.swift
//  Photo Transitioning
//
//  Created by c.c on 2019/6/14.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

public class PhotoGalleryController: UIViewController
{
    // MARK: - 属性
    weak var dataSource: IPhotoPresentingController!
    
    /// presentingView对应的index[用于滚到 到此处]
    var presentingIndex:Int?
    
    var presentingAnime: PhotoGalleryPresenting!
    var dismissAnime: PhotoGalleryDismising?
    
    /// 用于区分不同的galley
    var galleryIdentifier:String!
    
    var collectionView: UICollectionView!
    
    // MARK: -  生命周期
    
    public init(dataSource: IPhotoPresentingController, activeIndex:Int, identifier:String) {
        self.dataSource = dataSource
        self.presentingIndex = activeIndex
        self.galleryIdentifier = identifier
        
        let imageView = dataSource.ubmPhotoGallery(snapView: activeIndex, in: identifier)
        self.presentingAnime = PhotoGalleryPresenting(image: imageView)
        
        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = presentingAnime
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    // MARK:
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = true
        collectionView.frame = view.frame.insetBy(dx: -20.0, dy: 0.0)
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = UIColor.clear
        
        view.addSubview(collectionView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panRecognized))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        recalculateItemSize(inBoundingSize: self.view.bounds.size)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if presentingIndex != nil {
            let indexPath = IndexPath.init(item: presentingIndex!, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            presentingIndex = nil
        }
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        recalculateItemSize(inBoundingSize: size)
        if view.window == nil {
            view.frame = CGRect(origin: view.frame.origin, size: size)
            view.layoutIfNeeded()
        } else {
            let indexPath = self.collectionView?.indexPathsForVisibleItems.last
            coordinator.animate(alongsideTransition: { ctx in
                self.collectionView?.layoutIfNeeded()
            }, completion: { _ in
                if let indexPath = indexPath {
                    self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
            })
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func recalculateItemSize(inBoundingSize size: CGSize) {
        flowLayout.minimumLineSpacing = 40
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = size
    }
    
    @objc func panRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            //  Pan Gesture Recognizer continue from another Pan Gesture Recognizer
            handleDismiss(sender: sender)
        }
    }
    
    /// 出场
    private func handleDismiss(sender: Any?) {
        guard let cell = collectionView.visibleCells.first as? PhotoGalleryCell else { return }
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else { return }
        
        let imageView = cell.imageView!
        imageView.convert(imageView.bounds, to: nil)
        
        let currentFrame = imageView.convert(imageView.bounds, to: nil)
        
        let snapshotView = UIImageView(frame: currentFrame)
        snapshotView.image = cell.imageView.image
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.clipsToBounds = true
        snapshotView.backgroundColor = UIColor.red.withAlphaComponent(0.25)
        
        dismissAnime = PhotoGalleryDismising(indexPath: indexPath, snapshotView: snapshotView, galleryIdentifier: galleryIdentifier)
        
        if let panGesutre = sender as? UIPanGestureRecognizer {
            dismissAnime?.panGesutre = panGesutre
        }
        
        self.transitioningDelegate = dismissAnime
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoGalleryController: UIGestureRecognizerDelegate
{
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
            let translationIsVertical = (translation.y > 0) && (abs(translation.y) > abs(translation.x))
            
            return translationIsVertical
        }
        
        return true
    }
    
}
