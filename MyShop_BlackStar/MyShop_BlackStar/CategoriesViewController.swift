import UIKit

class CategoriesViewController: UIViewController, CategoriesLoad {
    var infoArray = [[String]]()
    var info = [CompareIDCategory]()
    
    let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!

    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesLoad(completion: { result in
            switch result {
            case .success(let z):
                DispatchQueue.main.async {
                    for (key, value) in z {
                        if key == "123" && value.name == "Предзаказ" { continue }
                        self.info.append(CompareIDCategory(id: key, myStruct: value))
                    }
                    self.info.sort(by: {$0.myStruct.sortOrder < $1.myStruct.sortOrder})
                    self.categoriesTableView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = categoriesTableView.indexPath(for: cell) {
            let vc = segue.destination as! SubCategoriesViewController
            vc.info = info[index.row].myStruct.subCategories
            if info[index.row].myStruct.subCategories.count == 0 {
                vc.extraID = Int(info[index.row].id)
            }
        }
    }
    
    //парсинг
    func categoriesLoad(completion: @escaping (Result<Welcome, Error>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                completion(.success(try decoder.decode(Welcome.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! CategoryTableViewCell
        if info[indexPath.row].myStruct.iconImage != "" {
            let url = URL(string: "https://blackstarshop.ru/" + info[indexPath.row].myStruct.iconImage)!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        } else {
            let url = URL(string: "https://wahki.mameau.com/images/0/0a/NoLogo.jpg")!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        }
        cell.nameLabel.text = info[indexPath.row].myStruct.name
        return cell
    }
}
	
