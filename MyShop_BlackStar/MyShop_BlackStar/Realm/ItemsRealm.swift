import Foundation
import RealmSwift

class ItemsRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var descript = ""
    @objc dynamic var colorName = ""
    @objc dynamic var mainImageURL = ""
    dynamic var productImagesURL = List<String>()
    @objc dynamic var size = ""
    @objc dynamic var price = 0
    @objc dynamic var oldPrice = 0
    @objc dynamic var tag = ""
    @objc dynamic var quantity = 0
}
