//
//  ImageItemStore.swift
//  VideoBrowserDomainModels
//
//  Created by James Honeyball on 16/07/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import UIKit

public class ImageItemStore {
    
    private var imageItemDictionary: [ImageUUID: ImageItem] = [ImageUUID: ImageItem]()
    private var lowResLoadingQueue = OperationQueue()
    private var bestResLoadingQueue = OperationQueue()

    init() {
        lowResLoadingQueue.maxConcurrentOperationCount = 1
        bestResLoadingQueue.maxConcurrentOperationCount = 1
        lowResLoadingQueue.qualityOfService = .userInitiated
        bestResLoadingQueue.qualityOfService = .default
        
        
    }
    
    func new () -> ImageUUID {
        let imageItem: ImageItem = ImageItemStruct()
        let hashValue: ImageUUID = UUID().hashValue
        imageItemDictionary.updateValue(imageItem, forKey: hashValue)
        return hashValue
    }
    
    func update (_ hashValue: ImageUUID, imageURL urlString: String, completion: @escaping () -> ()) {

        
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        //    let urlSession = URLSession.shared
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let urlSession = URLSession(configuration: config)
        
        
        let dataTask = urlSession.dataTask(with: urlRequest)
        {(data, urlResponse, error) in
            if error != nil {
                print("Error \(error!.localizedDescription )")
            } else if data != nil {
                let image = UIImage(data: data!)
                self.imageItemDictionary.updateValue(ImageItemStruct(image: image), forKey: hashValue)
            }
            completion()
        }
        dataTask.resume()
    }

    func get (_ imageUUID: ImageUUID) -> ImageItem? {
        let imageItem = imageItemDictionary[imageUUID]
        return imageItem
    }
    
}

public typealias ImageUUID = Int


struct ImageItemStruct: ImageItem {
    var image: UIImage?
}


class loadImageOperation: Operation {
    
    
    
    
    override func main() {
        print ("Loading image")
    }
}

