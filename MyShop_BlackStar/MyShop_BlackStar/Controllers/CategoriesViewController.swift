import UIKit

class CategoriesViewController: UIViewController, CategoriesLoad {
    
    var info = [CompareIDCategory]()
    
    let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!

    @IBOutlet weak var categoriesTableView: UITableView!
    
    var myAI: ActivityIndicator?
    
    override func viewDidLoad() {
        myAI = ActivityIndicator(view: self.view)
        DispatchQueue.main.async {
            self.startAnimating()
        }
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
                    self.stopAnimating()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
                print(err.localizedDescription)
            }
        })
        super.viewDidLoad()
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

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if info[indexPath.row].myStruct.subCategories.count != 0 {
            let vc = storyboard?.instantiateViewController(identifier: "subCategories") as! SubCategoriesViewController
            vc.info = info[indexPath.row].myStruct.subCategories
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "items") as! ItemsViewController
            vc.urlString += String(info[indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
//                show(vc, sender: nil)
//                present(vc, animated: true, completion: nil)
        }
    }
}
	
extension CategoriesViewController: AIFunctional {
    func startAnimating() {
        myAI!.activityIndicator.startAnimating()
        self.view.addSubview(myAI!.backgorundView)
        self.view.addSubview(myAI!.activityIndicator)
    }
    
    func stopAnimating() {
        myAI!.activityIndicator.stopAnimating()
        myAI!.activityIndicator.removeFromSuperview()
        myAI!.backgorundView.removeFromSuperview()
    }
}
