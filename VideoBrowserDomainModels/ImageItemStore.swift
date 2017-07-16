//
//  ImageItemStore.swift
//  VideoBrowserDomainModels
//
//  Created by James Honeyball on 16/07/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import UIKit

public struct ImageItemStore {
    
    private var imageItemDictionary: [ImageUUID: ImageItem]
    func add (_ urlString: String) -> ImageUUID {
        return UUID().hashValue
    }
    func get (_ imageUUID: ImageUUID) -> UIImage? {
        return nil
    }
    
}

public typealias ImageUUID = Int
