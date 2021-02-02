import UIKit
import Alamofire
import AlamofireImage


class SubCategoriesViewController: UIViewController {
    
    @IBOutlet weak var subCategoriesTable: UITableView!
    
    var info = [SubCategory]()
    var extraID: Int? = nil
    
    var myAI: ActivityIndicator?
    
    override func viewDidLoad() {
        
        myAI = ActivityIndicator(view: self.view)
        startAnimating()
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.info.sort(by: {$0.sortOrder < $1.sortOrder && $0.name < $1.name})
        }
        stopAnimating()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = subCategoriesTable.indexPath(for: cell) {
            let vc = segue.destination as! ItemsViewController
            vc.urlString += String(info[index.row].id)
        }
        if let _ = sender as? UIButton {
            let vc = segue.destination as! ItemsViewController
            vc.urlString += String(extraID!)
        }
    }
}

extension SubCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategory") as! CategoryTableViewCell
        if info[indexPath.row].iconImage != "" {
            let url = URL(string: "https://blackstarshop.ru/" + info[indexPath.row].iconImage)!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        } else {
            let url = URL(string: "https://wahki.mameau.com/images/0/0a/NoLogo.jpg")!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        }
        cell.nameLabel.text = info[indexPath.row].name
        return cell
    }
}

extension SubCategoriesViewController: AIFunctional {
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

