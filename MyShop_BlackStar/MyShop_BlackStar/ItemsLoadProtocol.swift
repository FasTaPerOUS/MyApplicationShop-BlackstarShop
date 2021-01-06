import Foundation

protocol ItemsLoad {
    func itemsLoad(completion: @escaping (Result<ItemsWithID, Error>) -> Void)
}
