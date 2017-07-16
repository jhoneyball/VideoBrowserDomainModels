
import UIKit
import VideoBrowserDataSources


public class VideoItemStore {
    
    public var videoItems: [VideoItem] = [VideoItem]()
    
    public enum ResourceType {
        case file
    }
    
    public init?(from: ResourceType, with location: String) {
        
        let videoJSONFeed = VideoJSONFeed(fromFile: "Feed", ofType: "json", in: Bundle.main)!
        
        if let videoItemsParser = VideoJSONParser(from: videoJSONFeed.theJSONData) {
            for videoDataItem in videoItemsParser.videoDataItems {
                let videoItem = VideoItemStruct(title: videoDataItem.title,
                                                synopsis: videoDataItem.synopsis,
                                                broadcastChannel: videoDataItem.broadcastChannel,
                                                imageItemStoreUUID: nil)
                videoItems.append(videoItem as VideoItem)
            }
        }
    }
}



struct VideoItemStruct: VideoItem {
    var title: String
    var synopsis: String
    var broadcastChannel: String
    var imageItemStoreUUID: ImageUUID?
}
