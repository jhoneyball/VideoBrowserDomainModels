//
//  ImageItemStore.swift
//  VideoBrowserDomainModels
//
//  Created by James Honeyball on 16/07/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import UIKit

enum Size {
    case small
    case best
}

public class ImageItemStore {
    
    private var imageItemDictionary: ImageItemDictionary = ImageItemDictionary()
    private var highPritoityLoadingQueue = OperationQueue()
    private var LowPritoityLoadingQueue = OperationQueue()

    init() {
        highPritoityLoadingQueue.maxConcurrentOperationCount = 1
        LowPritoityLoadingQueue.maxConcurrentOperationCount = 1
        highPritoityLoadingQueue.qualityOfService = .userInitiated
        LowPritoityLoadingQueue.qualityOfService = .default
    }
    
    func new () -> ImageUUID {
        let imageItem: ImageItem = ImageItemStruct()
        let hashValue: ImageUUID = UUID().hashValue
        imageItemDictionary.updateValue(imageItem, forKey: hashValue)
        return hashValue
    }
    
    func update (_ imageUUID: ImageUUID, imageURL urlString: String, size: Size, completion: @escaping () -> ()) {

        let loadImageOperation: LoadImageOperation = LoadImageOperation(imageUUID, imageItemDictionary: imageItemDictionary, url: urlString, size: size, completion: completion)
        if size == .small {
            highPritoityLoadingQueue.addOperation(loadImageOperation)
        } else {
            LowPritoityLoadingQueue.addOperation(loadImageOperation)
        }
    }

    func get (_ imageUUID: ImageUUID) -> ImageItem? {
        let imageItem = imageItemDictionary.get(imageUUID)
        return imageItem
    }
    
    func escalateSmall (_ imageUUID: ImageUUID) {
        var found = false
        
        for operation in highPritoityLoadingQueue.operations  {
            let lowOperation: LoadImageOperation = operation as! LoadImageOperation
            if lowOperation.isReady && lowOperation.imageUUID == imageUUID {
                found = true
                print("found imageUUID \(lowOperation.imageUUID)")
                operation.queuePriority = .high
            } else {
                operation.queuePriority = .normal
            }
        }
        if found == false {
            print("Didn't find \(imageUUID)")
        }
    }
    func escalateBest (_ imageUUID: ImageUUID) {
        var found = false
        for operation in LowPritoityLoadingQueue.operations  {
            let bestOperation: LoadImageOperation = operation as! LoadImageOperation
            if bestOperation.isReady && bestOperation.imageUUID == imageUUID {
                found = true
                print("found imageUUID \(bestOperation.imageUUID)")
                operation.queuePriority = .high
            } else {
                operation.queuePriority = .normal
            }
        }
        if found == false {
            print("Didn't find \(imageUUID)")
        }
    }
}

public typealias ImageUUID = Int


struct ImageItemStruct: ImageItem {
    var image: UIImage?
}


class LoadImageOperation: Operation {
    
    let urlRequest: URLRequest
    let config: URLSessionConfiguration
    let urlSession: URLSession
    let url: URL
    let imageUUID: ImageUUID
    var imageItemDictionary: ImageItemDictionary
    let size: Size
    var completion: () -> ()
    
    init(_ imageUUID: ImageUUID, imageItemDictionary: ImageItemDictionary, url urlString: String, size: Size, completion: @escaping () -> ()) {
        self.url = URL(string: urlString)!
        self.urlRequest = URLRequest(url: url)
        self.size = size
        self.config = URLSessionConfiguration.default
        self.config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.config.urlCache = nil
        self.urlSession = URLSession(configuration: config)
        self.imageItemDictionary = imageItemDictionary
        self.imageUUID = imageUUID
        self.completion = completion
    }
    
    override func main() {
        print("Begining image download of \(self.size) \(self.imageUUID)")
        let imageData = NSData(contentsOf: url)
//        let dataTask = urlSession.dataTask(with: urlRequest)
//        {(data, urlResponse, error) in
//            if error != nil {
//                print("Error \(error!.localizedDescription )")
//            } else if data != nil {
//                let image = UIImage(data: data!)
//                self.imageItemDictionary.updateValue(ImageItemStruct(image: image), forKey: self.imageUUID)
//                print("Downloaded image \(self.imageUUID)")
//            }
//        self.completion()
//        }
//        dataTask.resume()
        if let length = imageData?.length {
            if length > 0 {
                let image = UIImage(data: imageData! as Data)
                self.imageItemDictionary.updateValue(ImageItemStruct(image: image), forKey: self.imageUUID)
                print("Downloaded image \(self.size) \(self.imageUUID)")
            } else {
                print("Error downloading")
            }
        }
        self.completion()
    }
}

class ImageItemDictionary {
    private var imageDictionary: [ImageUUID: ImageItem] = [ImageUUID: ImageItem]()
    func updateValue(_ image: ImageItem, forKey imageUUID: ImageUUID) {
        imageDictionary.updateValue(image, forKey: imageUUID)
    }
    func get(_ imageUUID: ImageUUID) -> ImageItem? {
        return imageDictionary[imageUUID]
    }
}
