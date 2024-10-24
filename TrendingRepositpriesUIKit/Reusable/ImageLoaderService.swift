//
//  ImageLoaderService.swift
//  TrendingRepositpriesUIKit
//
//  Created by Zara on 12/06/2023.
//

import SDWebImage

public protocol ImageLoaderServiceType {
    static func loadImage(with url: String, _ completion: @escaping (UIImage?) -> Void)
}

public class ImageLoaderService: ImageLoaderServiceType {
    
    public init() {}
    
    public static func loadImage(with url: String, _ completion: @escaping (UIImage?) -> Void ) {
        SDWebImageManager.shared.loadImage(
            with: URL(string: url),
            options: .continueInBackground, 
            progress: nil,
            completed: { (image, data, error, cacheType, finished, url) in
                
                if let _ = error {
                    completion(nil)
                    return
                }
            
                guard let downloadedImage = image else {
                    completion(nil)
                    return
                }
                
                completion(downloadedImage)
            }
        )
    }
}
