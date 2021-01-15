import UIKit


protocol ItemControllerDelegate {
    func updateInfo(index: Int)
    func addItem(withSize: String)
}

class MultiViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    var info = [String]()
    var index = 0
    var checker = 0
    var text = ""
    
    var delegate: ItemControllerDelegate?
    
//    @IBOutlet weak var multiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = text
        // Do any additional setup after loading the view.
    }

}

extension MultiViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "color") as! MultiTableViewCell
        cell.nameLabel.text = info[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = info[indexPath.row]
        dismiss(animated: true, completion: nil)
        if checker == 0 {
            delegate?.updateInfo(index: indexPath.row)
        } else {
            delegate?.addItem(withSize: str)
        }
    }
    
}
