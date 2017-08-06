
import UIKit
import VideoBrowserDataSources


public class VideoItemStore {
    
    public var videoItems: [VideoItem] = [VideoItem]()
    public var imageItemStore: ImageItemStore = ImageItemStore()
    
    public enum ResourceType {
        case file
    }
    
    public init?(from: ResourceType, with location: String) {
        
        let videoJSONFeed = VideoJSONFeed(fromFile: "Feed", ofType: "json", in: Bundle.main)!
        
        if let videoItemsParser = VideoJSONParser(from: videoJSONFeed.theJSONData) {
            for videoDataItem in videoItemsParser.videoDataItems {
                
                let bestImageUUID = imageItemStore.new()
                let smallImageUUID = imageItemStore.new()
                
                let videoItem = VideoItemClass(title: videoDataItem.title,
                                                synopsis: videoDataItem.synopsis,
                                                broadcastChannel: videoDataItem.broadcastChannel,
                                                imageItemStore: imageItemStore,
                                                bestImageItemStoreUUID: bestImageUUID,
                                                smallImageItemStoreUUID: smallImageUUID)
                videoItems.append(videoItem as VideoItem)
                
                let bestImageURL = getImageURL(videoDataItem.imageURLs, for: URLImageResolution(640))
                let smallImageURL = getImageURL(videoDataItem.imageURLs, for: URLImageResolution(0))
                if smallImageURL != bestImageURL {
                    imageItemStore.update(smallImageUUID, imageURL: smallImageURL, completion: {imageForItemHasLoaded(videoItem)})
                }
                imageItemStore.update(bestImageUUID, imageURL: bestImageURL, completion: {imageForItemHasLoaded(videoItem)})
            }
        }
    }
}

class VideoItemClass: VideoItem {
    var title: String
    var synopsis: String
    var broadcastChannel: String
    var imageItemStore: ImageItemStore
    var bestImageItemStoreUUID: ImageUUID
    var smallImageItemStoreUUID: ImageUUID
    var image: UIImage? {if imageItemStore.get(bestImageItemStoreUUID)?.image != nil {
        return imageItemStore.get(bestImageItemStoreUUID)?.image
    } else {
        return imageItemStore.get(smallImageItemStoreUUID)?.image
        }
    }
    var delegate: VideoItemDelegate?
    init (title: String,
          synopsis: String,
          broadcastChannel: String,
          imageItemStore: ImageItemStore,
          bestImageItemStoreUUID: ImageUUID,
          smallImageItemStoreUUID: ImageUUID) {
        self.title = title
        self.synopsis = synopsis
        self.broadcastChannel = broadcastChannel
        self.imageItemStore = imageItemStore
        self.bestImageItemStoreUUID = bestImageItemStoreUUID
        self.smallImageItemStoreUUID = smallImageItemStoreUUID
    }
    
    func escalateImageLoad() {
        print("Escalated image load for: \(self.title)")
    }
}


func getImageURL(_ imageURLs: [ImageURLDetails], for resolution: URLImageResolution) -> String {
    
    var bestDifference = imageURLs.first!.resolution.pixels - resolution.pixels
    var bestImageURLDetails = imageURLs.first!
    
    for imageURL in imageURLs {
        let currentDifference = imageURL.resolution.pixels - resolution.pixels
        
        // if current image is bigger or equal than requested
        if currentDifference >= 0 {
            // if the current best image isn't bigger than requested
            if bestDifference < 0 {
                bestImageURLDetails = imageURL
                bestDifference = currentDifference
            } else {
                // if current image is closer to the requested than current best
                if currentDifference < bestDifference {
                    bestImageURLDetails = imageURL
                    bestDifference = currentDifference
                }
            }
        } else {
            // The current image is smaller than requested
            // If the best is smaller than requested and the current image is closer
            if (bestDifference < 0) && (currentDifference > bestDifference) {
                bestImageURLDetails = imageURL
                bestDifference = currentDifference
            }
        }
    }
    return bestImageURLDetails.url
}




func imageForItemHasLoaded(_ videoItem: VideoItem) -> Void {
    videoItem.delegate?.delegateAlertForImageLoaded()
}
