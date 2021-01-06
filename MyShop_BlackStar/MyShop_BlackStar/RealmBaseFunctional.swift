import Foundation

protocol RealmTableFunctional {
    func countAll() -> Int
    func delete(index: Int)
    func remove()
    func listAll() -> [ItemsRealm]
}
