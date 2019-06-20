//
//  RemoteImageResource.swift
//  ubmTotal
//
//  Created by c.c on 2019/2/22.
//  Copyright © 2019 mahao. All rights reserved.
//

import Foundation
import UIKit

/// 服务器端 图片资源
class ImageRemoteResource:NSObject {
    
    typealias SELF = ImageRemoteResource
    
    static let storage = NSCache<NSString, UIImage>()
    
    /// 图片资源
    private(set) var url:URL
    
    var callBack: ((UIImage) -> Void)?
    
    var image: UIImage? {
        return SELF.storage.object(forKey: url.absoluteString as NSString)
    }
    
    init(_ url:URL) {
        self.url = url
        super.init()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            //let data = try! Data.init(contentsOf: url)
            guard let data = try? Data.init(contentsOf: url) else {
                print(url.absoluteString)
                assertionFailure("异常")
                return
            }
            
            guard let image = UIImage.init(data: data) else {
                print(url.absoluteString)
                assertionFailure("异常")
                return
            }
            
            SELF.storage.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async { [weak self] in
                self?.callBack?(image)
            }
        }
        
    }
    
    /// 获取图片 主线程回掉
    func getImage(_ completion: @escaping (UIImage) -> Void) {
        
        let urlString = url.absoluteString
        
        // 如果直接有 那么直接返回
        if let imageFromCache = SELF.storage.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        // 如果没有 那么存入callBack
        self.callBack = completion
    }
    
    /// 获取图片 异步(查询+抓取) 主线程回掉，并存入全局缓存
    static func getImage(url: URL, completion: @escaping (UIImage) -> Void) {
        
        let urlString = url.absoluteString
        
        // 如果直接有 那么直接返回
        if let imageFromCache = SELF.storage.object(forKey: urlString as NSString) {
            completion(imageFromCache)
            return
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            guard let data = try? Data.init(contentsOf: url) else {
                print(url.absoluteString)
                assertionFailure("异常")
                return
            }
            
            guard let image = UIImage.init(data: data) else {
                print(url.absoluteString)
                assertionFailure("异常")
                return
            }
            
            SELF.storage.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
    }
    
    /// 获取图片 同步(仅查询)
    static func getImage(url: URL) -> UIImage? {
        
        let urlString = url.absoluteString
        
        // 如果直接有 那么直接返回
        if let imageFromCache = SELF.storage.object(forKey: urlString as NSString) {
            return imageFromCache;
        }
        
        return nil
    }
    
}
