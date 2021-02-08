import UIKit

class SubCategoriesViewController: UIViewController {
    
    @IBOutlet weak var subCategoriesTable: UITableView!
    
    var info = [SubCategory]()
    var extraID: Int? = nil
    var errImage = UIImageView()
    
    var myAI: ActivityIndicator?
    
    var images = [UIImageView]()
    
    let afClass = AlamofireImageClass()
    
    override func viewDidLoad() {
        myAI = ActivityIndicator(view: self.view)
        super.viewDidLoad()

        errImage = afClass.setImage(image: errImage, url: errURL)
        DispatchQueue.main.async {
            self.startAnimating()
        }
        info.sort(by: {$0.sortOrder < $1.sortOrder && $0.name < $1.name})
        for el in info {
            if el.iconImage == "" {
                DispatchQueue.main.async {
                    self.images.append(self.errImage)
                    self.subCategoriesTable.reloadData()
                }
            } else {
                let url = URL(string: mainURLString + el.iconImage)!
                var image = UIImageView()
                image = afClass.setImage(image: image, url: url)
                DispatchQueue.main.async {
                    self.images.append(image)
                    self.subCategoriesTable.reloadData()
                }
            }
        }
        DispatchQueue.main.async {
            self.stopAnimating()
        }
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
        if images.count == 0 {
            cell.logoImageView.image = errImage.image
        } else {
            cell.logoImageView.image = images[indexPath.row].image
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

