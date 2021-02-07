import Foundation
import RealmSwift

class RealmClass {
    let realm = try! Realm()
    
    func countItems() -> Int {
        let all = self.realm.objects(ItemsRealm.self)
        var sum = 0
        for el in all {
            sum += el.quantity
        }
        return sum
    }
    
    func addElement(info: OneItemWithAllColors, index: Int, size: String) {
        let all = self.realm.objects(ItemsRealm.self)
        for el in all {
            if el.name == info.name && el.colorName == info.colorName[index] && el.size == size {
            try! realm.write {
                el.quantity += 1
            }
                return
            }
        }
        let object = ItemsRealm()
        object.name = info.name
        object.descript = info.description
        object.colorName = info.colorName[index]
        object.mainImageURL = info.mainImage[index]
        for el in info.productImages[index] {
            object.productImagesURL.append(el.imageURL)
        }
        object.size = size
        object.price = Int(info.price[index]) ?? 99999
        object.oldPrice = Int(info.oldPrice[index]) ?? 99999
        object.tag = info.tag[index]
        object.quantity = 1
        try! realm.write {
            realm.add(object)
        }
    }
    
    func remove() {
        let all = realm.objects(ItemsRealm.self)
        if all.count == 0 { return }
        try! realm.write {
            realm.delete(all)
        }
    }
    
    func countAll() -> Int {
        let all = realm.objects(ItemsRealm.self)
        return all.count
    }
    
    func delete(index: Int) -> Int {
        let all = realm.objects(ItemsRealm.self)
        let z = all[index].quantity
        try! realm.write {
            realm.delete(all[index])
        }
        return z
    }
    
    func listAll() -> [ItemsRealm] {
        let all = realm.objects(ItemsRealm.self)
        return all.createArray()
    }
    
    func createItemType(index: Int) -> OneItemWithAllColors {
        let all = realm.objects(ItemsRealm.self)
        let el = all[index]
        var pr = [ProductImage]()
        for a in el.productImagesURL {
            pr.append(ProductImage(imageURL: a, sortOrder: 0))
        }
        return OneItemWithAllColors(name: el.name, description: el.descript, colorName: [el.colorName], sortOrder: 0, mainImage: [el.mainImageURL], productImages: [pr], offers: [], price: [String(el.price)], oldPrice: [String(el.oldPrice)], tag: [el.tag])
    }
}

extension Results {
    func createArray() -> [Element] {
        return self.map { $0 }
    }
}
