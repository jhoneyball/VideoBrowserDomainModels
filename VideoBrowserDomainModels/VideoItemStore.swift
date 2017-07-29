
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
                
                let imageUUID = imageItemStore.new()
                let videoItem = VideoItemClass(title: videoDataItem.title,
                                                synopsis: videoDataItem.synopsis,
                                                broadcastChannel: videoDataItem.broadcastChannel,
                                                imageItemStore: imageItemStore,
                                                imageItemStoreUUID: imageUUID)
                videoItems.append(videoItem as VideoItem)
                
                let imageURL = getBestImageURL(videoDataItem.imageURLs, for: URLImageResolution(0)).url
                //if videoItem.title == "Chelsea v Sunderland" {
                    imageItemStore.update(imageUUID, imageURL: imageURL, completion: {imageForItemHasLoaded(videoItem)})
                //}
            }
        }
    }
}

class VideoItemClass: VideoItem {
    var title: String
    var synopsis: String
    var broadcastChannel: String
    var imageItemStore: ImageItemStore
    var imageItemStoreUUID: ImageUUID
    var image: UIImage? {return imageItemStore.get(imageItemStoreUUID)?.image}
    var delegate: VideoItemDelegate?
    init (title: String,
          synopsis: String,
          broadcastChannel: String,
          imageItemStore: ImageItemStore,
          imageItemStoreUUID: ImageUUID) {
        self.title = title
        self.synopsis = synopsis
        self.broadcastChannel = broadcastChannel
        self.imageItemStore = imageItemStore
        self.imageItemStoreUUID = imageItemStoreUUID
    }
    
    func escalateImageLoad() {
        
    }
}

func getImageURL(_ videoDataItem: VideoDataItem) -> String {
      return videoDataItem.imageURLs.first!.url
}


func getBestImageURL(_ imageURLs: [ImageURLDetails], for resolution: URLImageResolution) -> ImageURLDetails {
    
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
    return bestImageURLDetails
}




func imageForItemHasLoaded(_ videoItem: VideoItem) -> Void {
    print("loaded image for \(videoItem.title)")
    videoItem.delegate?.delegateAlertForImageLoaded()
}
