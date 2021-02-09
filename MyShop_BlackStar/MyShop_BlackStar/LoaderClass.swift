import Foundation

class Loader {
    
    func categoriesLoad(completion: @escaping (Result<[CompareIDCategory], Error>) -> Void) {
        URLSession.shared.dataTask(with: categoriesURL, completionHandler: {(data, response, error) in
            var info = [CompareIDCategory]()
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let z = try decoder.decode(Welcome.self, from: data)
                for (key, value) in z {
                    if key == "123" && value.name == "Предзаказ" { continue }
                    info.append(CompareIDCategory(id: key, myStruct: value))
                }
                info.sort(by: {$0.myStruct.sortOrder < $1.myStruct.sortOrder})
                completion(.success(info))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

    func itemsLoad(completion: @escaping (Result<ItemsWithID, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                completion(.success(try decoder.decode(ItemsWithID.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

}

