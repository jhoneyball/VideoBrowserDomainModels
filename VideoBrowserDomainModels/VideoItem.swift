import UIKit

public protocol VideoItem {
    var title: String {get}
    var synopsis: String {get}
    var broadcastChannel: String {get}
    var image: UIImage? {get}
    func escalateImageLoad()
    weak var delegate: VideoItemDelegate? {get set}
}
//weak and class?
public protocol VideoItemDelegate: class {
    func delegateAlertForImageLoaded()
}
