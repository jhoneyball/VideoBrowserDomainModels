import Foundation

public protocol VideoItem {
    var title: String {get}
    var synopsis: String {get}
    var broadcastChannel: String {get}
    var imageItemStoreUUID: ImageUUID? {get}
}

