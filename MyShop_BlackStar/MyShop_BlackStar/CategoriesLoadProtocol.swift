import Foundation

protocol CategoriesLoad {
    func categoriesLoad(completion: @escaping (Result<Welcome, Error>) -> Void)
    var infoArray: [[String]] { get set }
}
