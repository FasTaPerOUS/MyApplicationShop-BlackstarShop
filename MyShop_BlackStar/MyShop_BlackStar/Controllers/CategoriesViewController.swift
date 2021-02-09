import UIKit

class CategoriesViewController: UIViewController {
    
    var info = [CompareIDCategory]()

    @IBOutlet weak var categoriesTableView: UITableView!
    
    var myAI: ActivityIndicator?
    
    let realmClass = RealmClass()
    
    override func viewDidLoad() {
        myAI = ActivityIndicator(view: self.view)
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(realmClass.countItems())
            if tabItem.badgeValue == "0" {
                tabItem.badgeValue = nil
            }
        }
        DispatchQueue.main.async {
            self.startAnimating()
        }
        
        Loader().categoriesLoad { result in
            switch result {
            case .success(let z):
                DispatchQueue.main.async {
                    self.info = z
                    self.categoriesTableView.reloadData()
                    self.stopAnimating()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! CategoryTableViewCell
        if info[indexPath.row].myStruct.iconImage != "" {
            let url = URL(string: mainURLString + info[indexPath.row].myStruct.iconImage)!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        } else {
            let data = try? Data(contentsOf: errURL)
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
